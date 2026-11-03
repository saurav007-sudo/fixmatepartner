import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Make sure firebase_auth is imported
import 'package:fixmatepartner/view/jobdetail.dart';
import 'package:fixmatepartner/view/viewcompletedjob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/active case model.dart';
import '../viewmodel/active viewmodel.dart';

class CompletedPage extends StatefulWidget {
  CompletedPage({super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
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

  @override
  Widget build(BuildContext context) {
    // Get the current logged-in professional's ID
    String currentPartnerId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Consumer<ActiveViewModel>(
      builder: (context, activeViewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFEFF9FF),
          body: SizedBox(
            height: 800,
            width: 360,
            child: StreamBuilder<QuerySnapshot>(
              // Filtered by current partnerId and status completed/closed
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('partnerId', isEqualTo: currentPartnerId)
                  .where('status', whereIn: ['completed', 'closed'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No completed jobs found",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                  );
                }

                var jobDocs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  itemCount: jobDocs.length,
                  itemBuilder: (context, index) {
                    var jobData = jobDocs[index].data() as Map<String, dynamic>;
                    String jobId = jobDocs[index].id;

                    String? customerUserId = jobData['userId'] ?? jobData['customerId'];
                    String? partnerId = jobData['partnerId'] ?? currentPartnerId;
                    String initialCustomerName = jobData['customerName'] ?? 'Customer';
                    String initialPrice = jobData['basePrice']?.toString() ?? jobData['price']?.toString() ?? '0';
                    String? initialProfileImage = jobData['profileImage'] ?? jobData['image'] ?? jobData['imageUrl'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Container(
                        height: 210,
                        width: 340,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  FutureBuilder<DocumentSnapshot>(
                                    future: customerUserId != null
                                        ? FirebaseFirestore.instance.collection('users').doc(customerUserId).get()
                                        : Future.value(null),
                                    builder: (context, userSnapshot) {
                                      String? profileImageUrl = initialProfileImage;

                                      if (userSnapshot.hasData && userSnapshot.data != null && userSnapshot.data!.exists) {
                                        var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                                        profileImageUrl = userData?['profileImage'] ??
                                            userData?['imageUrl'] ??
                                            userData?['image'] ??
                                            userData?['photoUrl'] ??
                                            initialProfileImage;
                                      }

                                      ImageProvider avatarImage;
                                      if (profileImageUrl != null && profileImageUrl.startsWith('http')) {
                                        avatarImage = NetworkImage(profileImageUrl);
                                      } else {
                                        avatarImage = const AssetImage("lib/image/logo.png");
                                      }

                                      return Container(
                                        height: 48,
                                        width: 42,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(21),
                                          image: DecorationImage(
                                            image: avatarImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          jobData['serviceName'] ?? 'Service',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.blue.shade900,
                                          ),
                                        ),
                                        FutureBuilder<DocumentSnapshot>(
                                          future: customerUserId != null
                                              ? FirebaseFirestore.instance.collection('users').doc(customerUserId).get()
                                              : Future.value(null),
                                          builder: (context, userSnapshot) {
                                            String displayName = initialCustomerName;

                                            if (userSnapshot.hasData && userSnapshot.data != null && userSnapshot.data!.exists) {
                                              var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                                              displayName = userData?['name'] ?? userData?['fullName'] ?? initialCustomerName;
                                            }

                                            return Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Row(
                                                children: [
                                                  const Icon(CupertinoIcons.person, size: 12, color: Colors.grey),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 4),
                                                    child: Text(
                                                      displayName,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey.shade700,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  // Fetch and display basePrice dynamically from partners collection
                                  FutureBuilder<String>(
                                    future: _fetchPartnerBasePrice(partnerId, initialPrice),
                                    builder: (context, priceSnapshot) {
                                      String displayPrice = priceSnapshot.data ?? initialPrice;

                                      return Container(
                                        height: 28,
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "₹$displayPrice",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.green.shade800,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    const Icon(CupertinoIcons.location_solid, size: 13, color: Colors.red),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        jobData['location'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    const Icon(CupertinoIcons.time, size: 13, color: Colors.grey),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        jobData['date'] ?? jobData['time'] ?? 'Completed',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  height: 32,
                                  width: 320,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        jobData['description'] ?? 'No description provided',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CompletedDetailsPage(jobId: jobId),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 38,
                                    width: 320,
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade700,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "VIEW DETAILS",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}