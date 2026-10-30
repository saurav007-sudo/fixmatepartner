import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixmatepartner/view/jobdetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/active case model.dart';
import '../viewmodel/active viewmodel.dart';

class Active extends StatefulWidget {
  Active({super.key});

  @override
  State<Active> createState() => _ActiveState();
}

class _ActiveState extends State<Active> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveViewModel>(
      builder: (context, activeViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder<QuerySnapshot>(
            stream: activeViewModel.getActiveJobsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "No active jobs found",
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
                    padding: EdgeInsets.only(
                      left: 14,
                      right: 14,
                      bottom: 20,
                    ),
                    child: Container(
                      height: 275,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.blue),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
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

                                    return CircleAvatar(
                                      radius: 34,
                                      backgroundColor: Colors.green,
                                      backgroundImage: avatarImage,
                                    );
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        jobData['serviceName'] ?? 'Service',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.blue[900],
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
                                            padding: EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.person_fill,
                                                  color: Colors.grey[600],
                                                  size: 15,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 6),
                                                  child: Text(
                                                    displayName,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[700],
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
                                StreamBuilder<DocumentSnapshot>(
                                  stream: activeViewModel.getLiveBookingStream(jobId),
                                  builder: (context, bookingSnapshot) {
                                    var bookingData = bookingSnapshot.data?.data() as Map<String, dynamic>?;

                                    ActiveJobModel activeJob = ActiveJobModel.fromMaps(
                                      jobData,
                                      bookingData,
                                      jobId,
                                    );

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 18.0, left: 7),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFE8F4FF),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          "₹${activeJob.price}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3, top: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.location_fill,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      jobData['location'] ?? '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3, top: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.time,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      jobData['time'] ?? 'Today',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4F6F9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      jobData['description'] ?? 'No description provided',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  Expanded(
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
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[900],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "TRACK",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
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
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}