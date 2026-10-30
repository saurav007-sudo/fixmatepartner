import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixmatepartner/view/tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'earnings view.dart';
import 'home view.dart';
import 'profile view.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int select = 0;

  final List page = [
    Home(),
    Jobs(),
    EarningsPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: select,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue, // Blue theme matching your screenshot
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,

        onTap: (index) {
          setState(() {
            select = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Filled home icon as shown in reference
          ),
          BottomNavigationBarItem(
            label: "Jobs",
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
          ),

          BottomNavigationBarItem(
            label: "Earnings",
            icon: Icon(Icons.currency_rupee_outlined), // Rupee symbol matching your screenshot
            activeIcon: Icon(Icons.currency_rupee),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
          ),
        ],
      ),
      body: page[select],
    );
  }
}