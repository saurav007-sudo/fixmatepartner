import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/verify model.dart';
import '../view/experience view.dart';
import '../view/government id view.dart';
import '../viewmodel/verify viewmodel.dart';

class VerifyProfile extends StatefulWidget {
  const VerifyProfile({super.key});

  @override
  State<VerifyProfile> createState() => _VerifyProfileState();
}

class _VerifyProfileState extends State<VerifyProfile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<VerifyProfileViewModel>(
      builder: (context, verifyViewModel, child) {
        return Scaffold(
          backgroundColor: Color(0xFFEFF9FF),
          body: StreamBuilder<DocumentSnapshot>(
            stream: verifyViewModel.getPartnerProfileStream(),
            builder: (context, snapshot) {
              var data = snapshot.data?.data() as Map<String, dynamic>?;
              VerifyProfileModel verifyModel = VerifyProfileModel.fromMap(data);

              return ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 25, bottom: 5, right: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 98,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(0, 4),
                              )
                            ],
                            color: Color(0xFFE7F3FF),
                            image: DecorationImage(
                              image: AssetImage("lib/image/logo.png"),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Verify Your Profile",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Complete verification to start accepting jobs.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: verifyViewModel.titleList.length,
                      itemBuilder: (context, index) {
                        bool isItemVerified = (index == 0 && verifyModel.idVerified) || (index == 1 && verifyModel.expVerified);

                        return Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 6),
                          child: GestureDetector(
                            onTap: () {
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => GovernmentIdPage()),
                                );
                              } else if (index == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ExperiencePage()),
                                );
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 330,
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
                                    padding: EdgeInsets.only(left: 15),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: verifyViewModel.bgColorList[index],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        verifyViewModel.iconList[index],
                                        color: verifyViewModel.iconColorList[index],
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      verifyViewModel.titleList[index],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(right: 3.0),
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        isItemVerified ? CupertinoIcons.checkmark_alt_circle_fill : CupertinoIcons.arrow_right,
                                        size: 18,
                                        color: isItemVerified ? Colors.green : Colors.black,
                                      ),
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
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: GestureDetector(
                      onTap: () async {
                        bool success = await verifyViewModel.submitForVerification();
                        if (!context.mounted) return;
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Verification request submitted to Admin!")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error submitting verification request")),
                          );
                        }
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Submit for Verification",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(
                                CupertinoIcons.arrow_right,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
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