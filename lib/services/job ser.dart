import 'package:flutter/material.dart';

import '../models/job model.dart';

class JobsServices {
  List<JobModel> fetchInitialJobs() {
    return [
      JobModel(
        jobTitle: "Electrical Repair",
        clientName: "Saurav K",
        location: "2.2 km • Kadavanthra, Kochi",
        time: "Today, 4:00 PM",
        price: "₹499",
        description: "Power socket is not working.",
        avatar: "lib/image/ELECT.jpg",
      ),
      JobModel(
        jobTitle: "Fan Installation",
        clientName: "Rahul Menon",
        location: "3.1 km • Fort Kochi, Kochi",
        time: "Today, 6:00 PM",
        price: "₹399",
        description: "Install ceiling fan in living room.",
        avatar: "lib/image/ELECT.jpg",
      ),
    ];
  }

  void removeJob(List<JobModel> jobs, int index) {
    if (index >= 0 && index < jobs.length) {
      jobs.removeAt(index);
    }
  }

  void acceptJobService(BuildContext context, List<JobModel> jobs, int index) {
    if (index >= 0 && index < jobs.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Accepted job: ${jobs[index].jobTitle}")),
      );
      removeJob(jobs, index);
    }
  }
}