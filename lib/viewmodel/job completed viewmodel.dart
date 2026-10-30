import 'package:flutter/material.dart';

import '../repository/job completed rep.dart';

class JobCompletedViewModel extends ChangeNotifier {
  final JobCompletedRepository _repository = JobCompletedRepository();

  void navigateToHome(BuildContext context) {
    _repository.navigateHome(context);
    notifyListeners();
  }
}