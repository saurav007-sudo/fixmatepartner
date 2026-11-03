import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmatepartner/view/payment%20page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CompletedDetailsPage extends StatefulWidget {
  final String jobId;
  const CompletedDetailsPage({super.key, required this.jobId});

  @override
  State<CompletedDetailsPage> createState() => _CompletedDetailsPageState();
}

class _CompletedDetailsPageState extends State<CompletedDetailsPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  // Helper method to fetch basePrice from partners collection
  Future<String> _fetchPartnerBasePrice(String? partnerId, String fallbackPrice) async {
    if (partnerId == null || partnerId.isEmpty) return fallbackPrice;
    try {
      // Check 'partners' collection first
      var doc = await FirebaseFirestore.instance.collection('partners').doc(partnerId).get();
      if (doc.exists && doc.data()?['basePrice'] != null) {
        return doc.data()!['basePrice'].toString();
      }

      // Fallback check 'partner' collection (singular)
      var docSingular = await FirebaseFirestore.instance.collection('partner').doc(partnerId).get();
      if (docSingular.exists && docSingular.data()?['basePrice'] != null) {
        return docSingular.data()!['basePrice'].toString();
      }
    } catch (e) {
      debugPrint("Error fetching partner base price: $e");
    }
    return fallbackPrice;
  }

  Future<void> _completeJob() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).update({
        'status': 'completed',
        'stopTime': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('bookings').doc(widget.jobId).update({
        'status': 'completed',
        'stopTime': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Job marked as completed successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSummaryPage(jobId: widget.jobId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to complete job: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not launch dialpad")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  void _showWaitingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .doc(widget.jobId)
              .snapshots(),
          builder: (context, snapshot) {
            String statusText = "Wait for customer's confirmation...";
            bool isFinished = false;
            Color textColor = Colors.black87;

            if (snapshot.hasData && snapshot.data!.exists) {
              var data = snapshot.data!.data() as Map<String, dynamic>?;
              var reachedFlag = data?['technicianReached'];

              if (reachedFlag == 'confirmed') {
                statusText = "Customer confirmed arrival!";
                textColor = Colors.green;
                isFinished = true;
                Future.delayed(const Duration(seconds: 1), () {
                  if (dialogContext.mounted && Navigator.canPop(dialogContext)) {
                    Navigator.pop(dialogContext);
                  }
                });
              } else if (reachedFlag == 'not_reached') {
                statusText = "Customer indicated you have not reached yet.";
                textColor = Colors.red;
                isFinished = true;
                Future.delayed(const Duration(seconds: 2), () {
                  if (dialogContext.mounted && Navigator.canPop(dialogContext)) {
                    Navigator.pop(dialogContext);
                  }
                });
              }
            }

            return AlertDialog(
              title: const Text("Arrival Status"),
              content: Row(
                children: [
                  isFinished
                      ? const SizedBox.shrink()
                      : const CircularProgressIndicator(),
                  if (!isFinished) const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      statusText,
                      style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              actions: isFinished
                  ? [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("OK"),
                ),
              ]
                  : null,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Job Details",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .doc(widget.jobId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "Job details not found",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          var jobData = snapshot.data!.data() as Map<String, dynamic>;

          String serviceName = jobData['serviceName'] ?? 'Service';
          String initialCustomerName = jobData['customerName'] ?? 'Customer';
          String? customerUserId = jobData['userId'] ?? jobData['customerId'];
          String? partnerId = jobData['partnerId'] ?? currentUser?.uid;
          String location = jobData['location'] ?? 'No location provided';
          String time = jobData['time'] ?? 'Today';
          String initialPrice = jobData['basePrice'] ?? jobData['price'] ?? '0';
          String description = jobData['description'] ?? 'No description provided';
          String initialPhone = jobData['phone'] ?? jobData['phoneNumber'] ?? jobData['phoneno'] ?? '';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: FutureBuilder<DocumentSnapshot>(
                  future: customerUserId != null
                      ? FirebaseFirestore.instance.collection('users').doc(customerUserId).get()
                      : Future.value(null),
                  builder: (context, userSnapshot) {
                    String customerName = initialCustomerName;
                    String customerPhone = initialPhone;
                    String? profileImageUrl = jobData['profileImage'] ?? jobData['image'] ?? jobData['imageUrl'];

                    if (userSnapshot.hasData && userSnapshot.data != null && userSnapshot.data!.exists) {
                      var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                      customerName = userData?['name'] ?? userData?['fullName'] ?? initialCustomerName;
                      customerPhone = userData?['phoneno'] ?? userData?['phone'] ?? userData?['mobile'] ?? initialPhone;
                      profileImageUrl = userData?['profileImage'] ??
                          userData?['imageUrl'] ??
                          userData?['image'] ??
                          userData?['photoUrl'] ??
                          profileImageUrl;
                    }

                    ImageProvider avatarImage;
                    if (profileImageUrl != null && profileImageUrl.startsWith('http')) {
                      avatarImage = NetworkImage(profileImageUrl);
                    } else {
                      avatarImage = const AssetImage("lib/image/logo.png");
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xFFE8F4FF),
                              backgroundImage: avatarImage,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customerName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    serviceName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  if (customerPhone.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    GestureDetector(
                                      onTap: () => _makePhoneCall(customerPhone),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.phone, size: 14, color: Colors.green),
                                          const SizedBox(width: 4),
                                          Text(
                                            customerPhone,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Fetch and display basePrice from partners collection dynamically
                            FutureBuilder<String>(
                              future: _fetchPartnerBasePrice(partnerId, initialPrice),
                              builder: (context, priceSnapshot) {
                                String displayPrice = priceSnapshot.data ?? initialPrice;

                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F4FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "₹$displayPrice",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.blue,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const Divider(height: 30),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.time, size: 16, color: Colors.black54),
                            const SizedBox(width: 8),
                            Text(
                              "Scheduled Time: $time",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(CupertinoIcons.location_solid, size: 16, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Location: $location",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Problem Description",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"$description"',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}