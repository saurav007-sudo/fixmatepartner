import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/government model.dart';
import '../repository/government id rep.dart';

class GovernmentIdViewModel extends ChangeNotifier {
  final GovernmentIdRepository _repository = GovernmentIdRepository();

  final TextEditingController idTypeController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();

  XFile? frontImageFile;
  XFile? backImageFile;

  String? frontImageUrl;
  String? backImageUrl;

  bool isLoading = false;

  Future<void> pickAndUploadImage(bool isFront) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    if (isFront) {
      frontImageFile = pickedFile;
    } else {
      backImageFile = pickedFile;
    }
    notifyListeners();

    isLoading = true;
    notifyListeners();

    String? downloadUrl = await _repository.uploadImage(pickedFile);

    isLoading = false;
    if (downloadUrl != null) {
      if (isFront) {
        frontImageUrl = downloadUrl;
      } else {
        backImageUrl = downloadUrl;
      }
    }
    notifyListeners();
  }

  Future<bool> submitGovernmentId() async {
    if (idTypeController.text.trim().isEmpty ||
        idNumberController.text.trim().isEmpty ||
        frontImageUrl == null ||
        backImageUrl == null) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? 'sample_partner';

      GovernmentIdModel model = GovernmentIdModel(
        idType: idTypeController.text.trim(),
        idNumber: idNumberController.text.trim(),
        idFrontUrl: frontImageUrl!,
        idBackUrl: backImageUrl!,
      );

      await _repository.submitId(uid, model);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Error submitting ID: $e");
      return false;
    }
  }

  @override
  void dispose() {
    idTypeController.dispose();
    idNumberController.dispose();
    super.dispose();
  }
}