import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmatepartner/view/editpersonal view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/personal info model.dart';
import '../viewmodel/personal info viewmodel.dart';

class Personal extends StatefulWidget {
  const Personal({super.key});

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonalInfoViewModel>(
      builder: (context, personalViewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFEFF9FF),
          body: SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
              stream: personalViewModel.getPartnerProfileStream(),
              builder: (context, snapshot) {
                var data = snapshot.data?.data() as Map<String, dynamic>?;
                PersonalInfoModel personal = PersonalInfoModel.fromMap(data);

                ImageProvider avatarImage;
                if (personal.profileImageUrl != null && personal.profileImageUrl!.isNotEmpty) {
                  avatarImage = NetworkImage(personal.profileImageUrl!);
                } else {
                  avatarImage = const AssetImage("lib/asset/44-extractpics.jpg");
                }

                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 10,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              CupertinoIcons.arrow_left,
                              size: 28,
                              color: Colors.blue[900],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 22,
                            ),
                            child: Text(
                              "Personal Information",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 13,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // Pass current values to the Edit page (phone omitted)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Edit(
                                      initialName: personal.name,
                                      initialEmail: personal.email,
                                    ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 23,
                                backgroundColor: const Color(0xFFDCEEFF),
                                child: Icon(
                                  CupertinoIcons.pencil,
                                  color: Colors.blue[800],
                                  size: 21,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        top: 18,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 52,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 48,
                              backgroundImage: avatarImage,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 18,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  personal.name,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    right: 8,
                                  ),
                                  child: Text(
                                    personal.category,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: 20,
                      ),
                      child: Container(
                        height: 200, // Adjusted height for Name and Email only
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 15,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 27,
                                    backgroundColor: const Color(0xFFE7F3FF),
                                    child: Icon(
                                      CupertinoIcons.person,
                                      color: Colors.blue[800],
                                      size: 25,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Full name",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 3,
                                          ),
                                          child: Text(
                                            personal.name,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 80,
                                right: 15,
                                top: 7,
                              ),
                              child: Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 9,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 27,
                                    backgroundColor: const Color(0xFFE7F3FF),
                                    child: Icon(
                                      CupertinoIcons.mail,
                                      color: Colors.blue[800],
                                      size: 25,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Email address",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 3,
                                          ),
                                          child: Text(
                                            personal.email,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: 18,
                        bottom: 30,
                      ),
                      child: Container(
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 20,
                                top: 17,
                              ),
                              child: Text(
                                "Account Information",
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                top: 15,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 17,
                                    backgroundColor: const Color(0xFFF0F0F0),
                                    child: Icon(
                                      CupertinoIcons.calendar,
                                      size: 17,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: Text(
                                      "Member since: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "2026",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                top: 12,
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 17,
                                    backgroundColor: Color(0xFFDDF7E8),
                                    child: Icon(
                                      CupertinoIcons.checkmark,
                                      size: 17,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: Text(
                                      "Account status: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Verified",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}