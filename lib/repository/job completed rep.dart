import 'package:flutter/material.dart';

import '../services/job completed ser.dart';

class JobCompletedRepository {
  final JobCompletedServices _services = JobCompletedServices();

  void navigateHome(BuildContext context) {
    _services.navigateToHomeService(context);
  }
}