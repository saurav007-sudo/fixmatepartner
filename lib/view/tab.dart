import 'package:fixmatepartner/view/completed.dart';
import 'package:flutter/material.dart';

import 'active view.dart';
import 'camcelled view.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: Colors.black87,
            indicatorColor: Colors.grey,
            indicatorWeight: 5,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.black87,
            dividerHeight: 5,
            tabs: [
              Tab(text: "Active"),
            Tab(text: "Completed"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            Active(),
           CompletedPage(),
            Cancelled(),
          ],
        ),
      ),
    );
  }
}