import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/experience model.dart';
import '../repository/experience rep.dart';

class ExperienceViewModel extends ChangeNotifier {
  final ExperienceRepository _repository = ExperienceRepository();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController expController = TextEditingController();
  final TextEditingController qualController = TextEditingController();

  final List<String> categories = [
    "AC Service",
    "Electrical Repair",
    "Plumbing",
    "Cleaning",
    "Painting"
  ];

  String selectedCategory = "AC Service";
  bool isLoading = false;

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  Future<bool> saveExperience(BuildContext context) async {
    if (expController.text.trim().isEmpty || qualController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in years of experience and qualification.")),
      );
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? 'sample_partner';

      ExperienceModel experienceModel = ExperienceModel(
        experience: expController.text.trim(),
        qualification: qualController.text.trim(),
        selectedCategory: selectedCategory,
        description: descriptionController.text.trim(),
      );

      await _repository.saveExperience(uid, experienceModel);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();

      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving experience: $e")),
      );
      return false;
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    expController.dispose();
    qualController.dispose();
    super.dispose();
  }
}