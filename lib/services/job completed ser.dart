import 'package:flutter/material.dart';

import '../view/botom.dart';

class JobCompletedServices {
  void navigateToHomeService(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Bottom()),
          (route) => false,
    );
  }
}