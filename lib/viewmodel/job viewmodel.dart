import 'package:flutter/material.dart';

import '../models/job model.dart';
import '../repository/job rep.dart';

class JobsViewModel extends ChangeNotifier {
  final JobsRepository _repository = JobsRepository();

  late List<JobModel> jobs;

  JobsViewModel() {
    jobs = _repository.getInitialJobs();
  }

  void declineJob(int index) {
    _repository.declineJob(jobs, index);
    notifyListeners();
  }

  void acceptJob(BuildContext context, int index) {
    _repository.acceptJob(context, jobs, index);
    notifyListeners();
  }
}