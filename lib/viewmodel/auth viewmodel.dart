import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/auth model.dart';
import '../repository/auth rep.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final TextEditingController createNameController = TextEditingController();
  final TextEditingController createMailController = TextEditingController();
  final TextEditingController createPassController = TextEditingController();
  final TextEditingController createPass2Controller = TextEditingController();
  final TextEditingController createAddressController = TextEditingController();
  final TextEditingController createMobController = TextEditingController();

  int selectedCategoryIndex = -1;
  final List<String> serviceCategories = [
    "Electrical Repair",
    "Plumbing",
    "AC Service",
    "Cleaning",
    "Pest Control",
    "Painting"
  ];

  void selectCategory(int index) {
    selectedCategoryIndex = index;
    notifyListeners();
  }

  final TextEditingController loginMailController = TextEditingController();
  final TextEditingController loginPassController = TextEditingController();

  final TextEditingController forgotMailController = TextEditingController();

  Future<String?> signup() async {
    if (createPassController.text.trim() != createPass2Controller.text.trim()) {
      return "Passwords do not match";
    }

    if (selectedCategoryIndex == -1) {
      return "Please select a category";
    }

    _isLoading = true;
    notifyListeners();

    try {
      User? user = await _repository.signUp(
        createMailController.text.trim(),
        createPassController.text.trim(),
      );

      if (user != null) {
        String uid = user.uid;
        String selectedCategory = serviceCategories[selectedCategoryIndex];

        AuthModel authModel = AuthModel(
          uid: uid,
          name: createNameController.text.trim(),
          email: createMailController.text.trim(),
          address: createAddressController.text.trim(),
          phoneNo: createMobController.text.trim(),
          category: selectedCategory,
        );

        await _repository.savePartnerData(uid, authModel);
      }

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Failed to create account: $e";
    }
  }

  Future<bool> signin() async {
    if (loginMailController.text.trim().isEmpty || loginPassController.text.trim().isEmpty) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      User? user = await _repository.signIn(
        loginMailController.text.trim(),
        loginPassController.text.trim(),
      );
      _isLoading = false;
      notifyListeners();
      return user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendPasswordReset() async {
    var email = forgotMailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.sendPasswordReset(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      User? user = await _repository.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    createNameController.dispose();
    createMailController.dispose();
    createPassController.dispose();
    createPass2Controller.dispose();
    createAddressController.dispose();
    createMobController.dispose();
    loginMailController.dispose();
    loginPassController.dispose();
    forgotMailController.dispose();
    super.dispose();
  }
}