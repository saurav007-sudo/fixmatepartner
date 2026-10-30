import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmatepartner/view/privacy%20rules.dart';
import 'package:fixmatepartner/view/service%20and%20price%20view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/profile model.dart';
import '../view/personal info view.dart';
import '../viewmodel/profile viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, profileViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Professional Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: profileViewModel.getPartnerProfileStream(),
                builder: (context, snapshot) {
                  var data = snapshot.data?.data() as Map<String, dynamic>?;
                  ProfileModel profile = ProfileModel.fromMap(data);
                  String partnerId = FirebaseAuth.instance.currentUser?.uid ?? '';

                  ImageProvider? avatarBackgroundImage;
                  if (profile.profileImageUrl != null && profile.profileImageUrl!.isNotEmpty) {
                    avatarBackgroundImage = NetworkImage(profile.profileImageUrl!);
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 38,
                              backgroundColor: const Color(0xFFE1F0FF),
                              backgroundImage: avatarBackgroundImage,
                              child: avatarBackgroundImage == null
                                  ? const Icon(
                                CupertinoIcons.person_fill,
                                size: 45,
                                color: Colors.blue,
                              )
                                  : null,
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      profile.partnerName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      CupertinoIcons.checkmark_seal_fill,
                                      color: Colors.blue,
                                      size: 18,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    profile.category,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.star_fill,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "4.9",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.blue[900],
                                        ),
                                      ),
                                      const Text(
                                        " (320 reviews)",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          height: 75,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F6FA),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profile.expYears,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "Years Experience",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  height: 30,
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('bookings')
                                      .where('partnerId', isEqualTo: partnerId)
                                      .where('status', whereIn: ['completed', 'closed'])
                                      .snapshots(),
                                  builder: (context, bookingSnapshot) {
                                    int completedCount = 0;
                                    if (bookingSnapshot.hasData) {
                                      completedCount = bookingSnapshot.data!.docs.length;
                                    }

                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$completedCount+",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.blue[900],
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          "Jobs Completed",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Container(
                                  height: 30,
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "4.9",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.blue[900],
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      const Icon(
                                        CupertinoIcons.star_fill,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      "Rating",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 8),
                child: Text(
                  "My Profile",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: GestureDetector(
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Personal()));
                        } else if (index == 1) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ServicesPricing()));
                        } else if (index == 2) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  Terms(mdFilename: 'terms.md')));
                        }
                      },
                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.withOpacity(0.15)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE1F0FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  profileViewModel.profileIcons[index],
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                profileViewModel.profileTitles[index],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blue[900],
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                CupertinoIcons.chevron_right,
                                color: Colors.grey[400],
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: GestureDetector(
                  onTap: () => profileViewModel.signOut(context),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: Colors.red.withOpacity(0.2)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "LOGOUT",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.red[900],
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            CupertinoIcons.chevron_right,
                            color: Colors.grey[400],
                            size: 16,
                          ),
                        ],
                      ),
                    ),
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