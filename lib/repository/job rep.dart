import 'package:flutter/material.dart';

import '../models/job model.dart';
import '../services/job ser.dart';

class JobsRepository {
  final JobsServices _services = JobsServices();

  List<JobModel> getInitialJobs() {
    return _services.fetchInitialJobs();
  }

  void declineJob(List<JobModel> jobs, int index) {
    _services.removeJob(jobs, index);
  }

  void acceptJob(BuildContext context, List<JobModel> jobs, int index) {
    _services.acceptJobService(context, jobs, index);
  }
}