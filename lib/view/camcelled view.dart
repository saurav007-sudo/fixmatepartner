import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cancelled model.dart';
import '../viewmodel/cancelled viewmodel.dart';

class Cancelled extends StatelessWidget {
  const Cancelled({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CancelledJobsViewModel(),
      child: Consumer<CancelledJobsViewModel>(
        builder: (context, cancelledJobsViewModel, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Cancelled / Rejected Jobs"),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: cancelledJobsViewModel.getCancelledJobsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No cancelled/rejected jobs found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                var jobDocs = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.only(top: 8, bottom: 20),
                  itemCount: jobDocs.length,
                  itemBuilder: (context, index) {
                    var doc = jobDocs[index];
                    var jobData = doc.data() as Map<String, dynamic>;
                    CancelledJobModel job = CancelledJobModel.fromMap(jobData, doc.id);

                    String? customerUserId = jobData['userId'] ?? jobData['customerId'];
                    String initialCustomerName = job.customerName.isNotEmpty ? job.customerName : 'Customer';

                    String? profileImageUrl = jobData['profileImage'] ??
                        jobData['image'] ??
                        jobData['imageUrl'] ??
                        jobData['partnerImage'];

                    ImageProvider avatarImageProvider;
                    if (profileImageUrl != null && profileImageUrl.startsWith('http')) {
                      avatarImageProvider = NetworkImage(profileImageUrl);
                    } else {
                      avatarImageProvider = AssetImage("lib/image/logo.png");
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        left: 14,
                        right: 14,
                        bottom: 20,
                      ),
                      child: Container(
                        height: 230,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.red.shade300),
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
                                  CircleAvatar(
                                    radius: 34,
                                    backgroundColor: Colors.red,
                                    backgroundImage: avatarImageProvider,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          job.serviceName,
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
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 18.0, left: 7),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFEBEE),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "₹${job.price}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.red[800],
                                        ),
                                      ),
                                    ),
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
                                        job.location,
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
                                        job.time,
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
                                        job.description,
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
      ),
    );
  }
}