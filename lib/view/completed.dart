import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixmatepartner/view/jobdetail.dart';
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
  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveViewModel>(
      builder: (context, activeViewModel, child) {
        return Scaffold(
          backgroundColor: Color(0xFFEFF9FF),
          body: SizedBox(
            height: 800,
            width: 360,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('status', whereIn: ['completed', 'closed'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No completed jobs found",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                  );
                }

                var jobDocs = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.only(top: 8, bottom: 20),
                  itemCount: jobDocs.length,
                  itemBuilder: (context, index) {
                    var jobData = jobDocs[index].data() as Map<String, dynamic>;
                    String jobId = jobDocs[index].id;

                    String? customerUserId = jobData['userId'] ?? jobData['customerId'];
                    String initialCustomerName = jobData['customerName'] ?? 'Customer';
                    String? initialProfileImage = jobData['profileImage'] ?? jobData['image'] ?? jobData['imageUrl'];

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
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
                                        avatarImage = AssetImage("lib/image/logo.png");
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
                                    padding: EdgeInsets.only(left: 10),
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
                                              padding: EdgeInsets.only(top: 2),
                                              child: Row(
                                                children: [
                                                  Icon(CupertinoIcons.person, size: 12, color: Colors.grey),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 4),
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
                                  Spacer(),
                                  Container(
                                    height: 28,
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "₹${jobData['basePrice'] ?? jobData['price'] ?? '0'}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.green.shade800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.location_solid, size: 13, color: Colors.red),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Text(
                                        jobData['location'] ?? '',
                                        style: TextStyle(
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
                                padding: EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.time, size: 13, color: Colors.grey),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Text(
                                        jobData['date'] ?? jobData['time'] ?? 'Completed',
                                        style: TextStyle(
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
                                padding: EdgeInsets.only(top: 8),
                                child: Container(
                                  height: 32,
                                  width: 320,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        jobData['description'] ?? 'No description provided',
                                        style: TextStyle(
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
                                padding: EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JobDetailsPage(jobId: jobId),
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
                                    child: Center(
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