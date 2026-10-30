import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/job model.dart';
import '../viewmodel/job viewmodel.dart';


class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JobsViewModel>(
      builder: (context, jobsViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: jobsViewModel.jobs.isEmpty
              ? Center(
            child: Text(
              "No pending jobs available.",
              style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          )
              : ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 650,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: jobsViewModel.jobs.length,
                    itemBuilder: (context, index) {
                      JobModel job = jobsViewModel.jobs[index];
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
                                    CircleAvatar(
                                      radius: 34,
                                      backgroundColor: Colors.green,
                                      backgroundImage: AssetImage("lib/image/profile3.jpg"),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            job.jobTitle,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.blue[900],
                                            ),
                                          ),
                                          Padding(
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
                                                    job.clientName,
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
                                          color: Color(0xFFE8F4FF),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          job.price,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.blue[800],
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
                                Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => jobsViewModel.declineJob(index),
                                          child: Container(
                                            height: 45,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey.withOpacity(0.4),
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Decline",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.blue[900],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => jobsViewModel.acceptJob(context, index),
                                          child: Container(
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Accept Job",
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
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}