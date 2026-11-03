import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmatepartner/view/verify%20view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/home model.dart';
import '../viewmodel/home viewmodel.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Helper function to extract House and Area from full address string
  String _getHouseAndArea(String fullLocation) {
    if (fullLocation.isEmpty) return 'Location not provided';
    List<String> parts = fullLocation.split(',');
    if (parts.length >= 2) {
      return "${parts[0].trim()}, ${parts[1].trim()}";
    }
    return fullLocation.trim();
  }

  // Helper method to fetch basePrice from either 'partner' or 'partners' collection
  Future<String> _fetchPartnerBasePrice(String partnerId, String fallbackPrice) async {
    if (partnerId.isEmpty) return fallbackPrice;
    try {
      // Check 'partner' collection first
      var doc = await FirebaseFirestore.instance.collection('partner').doc(partnerId).get();
      if (doc.exists && doc.data()?['basePrice'] != null) {
        return doc.data()!['basePrice'].toString();
      }

      // Fallback check 'partners' collection
      var docPlural = await FirebaseFirestore.instance.collection('partners').doc(partnerId).get();
      if (docPlural.exists && docPlural.data()?['basePrice'] != null) {
        return docPlural.data()!['basePrice'].toString();
      }
    } catch (e) {
      debugPrint("Error fetching partner base price: $e");
    }
    return fallbackPrice;
  }

  @override
  Widget build(BuildContext context) {
    String currentPartnerId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFEFF9FF),
          body: SizedBox(
            height: 800,
            width: 360,
            child: ListView(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: homeViewModel.getPartnerProfileStream(),
                  builder: (context, snapshot) {
                    var data = snapshot.data?.data() as Map<String, dynamic>?;
                    HomeModel profile = HomeModel.fromPartnerMap(data);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                          child: Row(
                            children: [
                              Text(
                                "Welcome, ${profile.partnerName}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                height: 37,
                                width: 37,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(17),
                                  image: const DecorationImage(
                                    image: AssetImage("lib/image/logo.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left: 15, right: 15),
                          child: Row(
                            children: [
                              Text(
                                profile.category,
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                height: 26,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2F6EA),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Row(
                                  children: const [
                                    CircleAvatar(
                                      radius: 4,
                                      backgroundColor: Colors.green,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Text(
                                        "Available for Jobs",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!profile.isVerified)
                          Padding(
                            padding: const EdgeInsets.only(top: 12, left: 15, right: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const VerifyProfile()),
                                );
                              },
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: profile.isSubmitted ? const Color(0xFFFFF3E0) : const Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: profile.isSubmitted ? Colors.orange.shade300 : Colors.red.shade200,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            profile.isSubmitted
                                                ? CupertinoIcons.clock_fill
                                                : CupertinoIcons.exclamationmark_triangle_fill,
                                            size: 18,
                                            color: profile.isSubmitted ? Colors.orange.shade800 : Colors.red,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: Text(
                                              profile.isSubmitted
                                                  ? "Verification Pending (Admin Review)"
                                                  : "Profile not verified",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                                color: profile.isSubmitted ? Colors.orange.shade800 : Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        CupertinoIcons.arrow_right,
                                        size: 16,
                                        color: profile.isSubmitted ? Colors.orange.shade800 : Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                // Today's Earnings Card Section
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 15, right: 15),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: homeViewModel.getEarningsStream(),
                    builder: (context, earningsSnapshot) {
                      double todayTotalEarnings = 0.0;

                      if (earningsSnapshot.hasData) {
                        String todayString = DateFormat('d MMMM yyyy').format(DateTime.now());
                        DateTime now = DateTime.now();

                        for (var doc in earningsSnapshot.data!.docs) {
                          var data = doc.data() as Map<String, dynamic>;
                          String status = (data['status'] ?? '').toString().toLowerCase();

                          if (status == 'completed' || status == 'closed') {
                            bool isToday = false;
                            String bookingDate = data['date'] ?? '';

                            if (bookingDate == todayString) {
                              isToday = true;
                            } else {
                              dynamic timestampField = data['updatedAt'] ?? data['createdAt'] ?? data['timestamp'];
                              if (timestampField is Timestamp) {
                                DateTime dt = timestampField.toDate();
                                if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
                                  isToday = true;
                                }
                              }
                            }

                            if (isToday) {
                              double jobEarnings = double.tryParse(
                                data['technicianEarnings']?.toString() ??
                                    data['totalAmount']?.toString() ??
                                    data['basePrice']?.toString() ??
                                    data['price']?.toString() ??
                                    '0',
                              ) ??
                                  0.0;
                              todayTotalEarnings += jobEarnings;
                            }
                          }
                        }
                      }

                      return Container(
                        height: 114,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2979FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Today's Earnings",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "₹${todayTotalEarnings.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Completed Jobs Statistics Section (Cancelled Jobs removed)
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 15, right: 15),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: homeViewModel.getCompletedAndCancelledJobsStream(),
                    builder: (context, snapshot) {
                      int completedCount = 0;

                      if (snapshot.hasData) {
                        for (var doc in snapshot.data!.docs) {
                          var data = doc.data() as Map<String, dynamic>;
                          String status = (data['status'] ?? '').toString().toLowerCase();
                          if (status == 'completed' || status == 'closed') {
                            completedCount++;
                          }
                        }
                      }

                      return Container(
                        height: 85,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: const Text(
                                "Completed Jobs",
                                style: TextStyle(fontSize: 17, color: Colors.grey, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Center(
                              child: Text(
                                "$completedCount",
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18, left: 15, bottom: 8),
                  child: const Text(
                    "New Job Requests",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 450,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: homeViewModel.getPendingJobsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text("No new job requests available"),
                        );
                      }

                      var jobDocs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: jobDocs.length,
                        itemBuilder: (context, index) {
                          var doc = jobDocs[index];
                          var jobData = doc.data() as Map<String, dynamic>;
                          JobRequestModel job = JobRequestModel.fromMap(jobData, doc.id);
                          String targetPartnerId = jobData['partnerId'] ?? currentPartnerId;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: FutureBuilder<DocumentSnapshot>(
                                      future: job.userId != null
                                          ? homeViewModel.getUserDetails(job.userId!)
                                          : Future.value(null),
                                      builder: (context, userSnapshot) {
                                        String? profileImageUrl = jobData['profileImage'] ?? jobData['image'] ?? jobData['imageUrl'];

                                        if (userSnapshot.hasData && userSnapshot.data != null && userSnapshot.data!.exists) {
                                          var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
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

                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 28.0),
                                          child: Container(
                                            height: 95,
                                            width: 85,
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: avatarImage,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            job.serviceName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: job.userId != null
                                                ? FutureBuilder<DocumentSnapshot>(
                                              future: homeViewModel.getUserDetails(job.userId!),
                                              builder: (context, userSnapshot) {
                                                String customerName = "Loading...";
                                                if (userSnapshot.connectionState == ConnectionState.done &&
                                                    userSnapshot.hasData &&
                                                    userSnapshot.data!.exists) {
                                                  var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                                                  customerName = userData?['name'] ?? userData?['fullName'] ?? 'Customer';
                                                } else if (userSnapshot.hasError || !userSnapshot.hasData) {
                                                  customerName = job.customerName;
                                                }

                                                return Text(
                                                  "Customer: $customerName",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                );
                                              },
                                            )
                                                : Text(
                                              "Customer: ${job.customerName}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  CupertinoIcons.location_solid,
                                                  size: 11,
                                                  color: Colors.red,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 4),
                                                    child: Text(
                                                      _getHouseAndArea(job.location),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[700],
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Fetch and display basePrice from partners collection under Estimated service
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: FutureBuilder<String>(
                                              future: _fetchPartnerBasePrice(targetPartnerId, job.estimatedPrice),
                                              builder: (context, priceSnapshot) {
                                                String basePrice = priceSnapshot.data ?? job.estimatedPrice;

                                                return Text(
                                                  "Estimated service: ₹$basePrice",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => homeViewModel.updateJobStatus(job.id, 'rejected'),
                                                  child: Container(
                                                    height: 27,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(color: Colors.black),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        "Reject",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight: FontWeight.w800,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                                  child: Text("|", style: TextStyle(color: Colors.grey)),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    await homeViewModel.updateJobStatus(job.id, 'accepted');
                                                  },
                                                  child: Container(
                                                    height: 28,
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFF2979FF),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        "Accept Job Requests",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w800,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}