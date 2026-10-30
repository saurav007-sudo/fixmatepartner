import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixmatepartner/view/verify%20view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/home model.dart';
import '../viewmodel/home viewmodel.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        return Scaffold(
          backgroundColor: Color(0xFFEFF9FF),
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
                          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                          child: Row(
                            children: [
                              Text(
                                "Welcome, ${profile.partnerName}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 37,
                                width: 37,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(17),
                                  image: DecorationImage(
                                    image: AssetImage("lib/image/logo.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2, left: 15, right: 15),
                          child: Row(
                            children: [
                              Text(
                                profile.category,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 26,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE2F6EA),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Row(
                                  children: [
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
                            padding: EdgeInsets.only(top: 12, left: 15, right: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => VerifyProfile()),
                                );
                              },
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: profile.isSubmitted ? Color(0xFFFFF3E0) : Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: profile.isSubmitted ? Colors.orange.shade300 : Colors.red.shade200,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
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
                                            padding: EdgeInsets.only(left: 8),
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
                Padding(
                  padding: EdgeInsets.only(top: 12, left: 15, right: 15),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: homeViewModel.getEarningsStream(),
                    builder: (context, earningsSnapshot) {
                      double totalEarnings = 0.0;

                      if (earningsSnapshot.hasData) {
                        for (var doc in earningsSnapshot.data!.docs) {
                          var data = doc.data() as Map<String, dynamic>;
                          double jobEarnings = double.tryParse(data['technicianEarnings']?.toString() ?? '0') ?? 0.0;
                          totalEarnings += jobEarnings;
                        }
                      }

                      return Container(
                        height: 114,
                        decoration: BoxDecoration(
                          color: Color(0xFF2979FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16, top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today's Earnings",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  "₹${totalEarnings.toStringAsFixed(0)}",
                                  style: TextStyle(
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
                Padding(
                  padding: EdgeInsets.only(top: 18, left: 15, bottom: 8),
                  child: Text(
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
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
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

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: Offset(0, 4),
                                  )
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 12),
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
                                          avatarImage = AssetImage("lib/image/logo.png");
                                        }

                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 28.0),
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
                                      padding: EdgeInsets.only(left: 12, top: 12, right: 12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            job.serviceName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 4),
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
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                );
                                              },
                                            )
                                                : Text(
                                              "Customer: ${job.customerName}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 2),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.location_solid,
                                                  size: 11,
                                                  color: Colors.red,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 4),
                                                  child: Text(
                                                    job.location,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[700],
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 2),
                                            child: Text(
                                              "Estimated service: ₹${job.estimatedPrice}",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 6),
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
                                                    child: Center(
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
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                                  child: Text("|", style: TextStyle(color: Colors.grey)),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    await homeViewModel.updateJobStatus(job.id, 'accepted');
                                                  },
                                                  child: Container(
                                                    height: 28,
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF2979FF),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Center(
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