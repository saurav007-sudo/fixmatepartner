import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixmatepartner/view/withdraw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/earnings model.dart';
import '../viewmodel/earnings viewmodel.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EarningsViewModel>(
      builder: (context, earningsViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder<QuerySnapshot>(
            stream: earningsViewModel.getEarningsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              var rawDocs = snapshot.hasData ? snapshot.data!.docs : <QueryDocumentSnapshot>[];
              var docs = earningsViewModel.filterDocs(rawDocs);

              var summary = earningsViewModel.calculateSummary(docs);
              double thisMonthEarnings = summary['thisMonth'];
              double thisWeekEarnings = summary['thisWeek'];
              double todayEarnings = summary['today'];
              int totalJobs = summary['totalJobs'];

              return ListView(
                padding: EdgeInsets.only(bottom: 25),
                children: [
                  ListTile(
                    title: Text(
                      "My Earnings",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Color(0xFF0066FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "This Month",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    "₹${thisMonthEarnings.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.arrow_up_right,
                                        color: Colors.greenAccent,
                                        size: 16,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Text(
                                          "Live updates from database",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xFFF4F6FA),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "₹${thisWeekEarnings.toStringAsFixed(0)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.blue[900],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    "This Week",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xFFF4F6FA),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "₹${todayEarnings.toStringAsFixed(0)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.blue[900],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    "Today",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xFFF4F6FA),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$totalJobs",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.blue[900],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    "Jobs",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  docs.isEmpty
                      ? Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Center(
                      child: Text(
                        "No completed earnings yet.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: docs.length > 5 ? 5 : docs.length,
                    itemBuilder: (context, index) {
                      var jobData = docs[index].data() as Map<String, dynamic>;
                      EarningsModel earnings = EarningsModel.fromMap(jobData);

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Color(0xFFE1F0FF),
                                  child: Icon(
                                    CupertinoIcons.checkmark_alt,
                                    color: Colors.blue,
                                    size: 22,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      earnings.serviceName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 3),
                                      child: earnings.userId.isNotEmpty
                                          ? FutureBuilder<DocumentSnapshot>(
                                        future: earningsViewModel.getUserData(earnings.userId),
                                        builder: (context, userSnapshot) {
                                          String customerName = "Loading...";
                                          if (userSnapshot.connectionState == ConnectionState.done &&
                                              userSnapshot.hasData &&
                                              userSnapshot.data!.exists) {
                                            var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                                            customerName = userData?['name'] ?? userData?['fullName'] ?? 'Customer';
                                          } else if (userSnapshot.hasError || !userSnapshot.hasData) {
                                            customerName = earnings.customerName;
                                          }

                                          return Text(
                                            "${earnings.dateStr}\n$customerName",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          );
                                        },
                                      )
                                          : Text(
                                        "${earnings.dateStr}\n${earnings.customerName}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "₹${earnings.amount.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 3),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFDDF8F0),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "Completed",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.green[800],
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
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 20,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WithdrawEarnings()),
                        );
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "Withdraw Earnings",
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
              );
            },
          ),
        );
      },
    );
  }
}