import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/editpersonal model.dart';
import '../repository/editpersonal rep.dart';

class EditProfileViewModel extends ChangeNotifier {
  final EditProfileRepository _repository = EditProfileRepository();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  XFile? selectedImageFile;
  String? profileImageUrl;
  bool isLoading = false;

  Future<void> loadUserData() async {
    String uid = currentUser?.uid ?? 'sample_partner';
    EditProfileModel? profile = await _repository.getUserProfile(uid);
    if (profile != null) {
      nameController.text = profile.name;
      mailController.text = profile.email;
      phoneController.text = profile.phone;
      dobController.text = profile.dob;
      profileImageUrl = profile.profileImage;
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImageFile = pickedFile;
      notifyListeners();
    }
  }

  Future<bool> saveChanges() async {
    isLoading = true;
    notifyListeners();

    try {
      String uid = currentUser?.uid ?? 'sample_partner';
      String? finalImageUrl = profileImageUrl;

      if (selectedImageFile != null) {
        String? uploadedUrl = await _repository.uploadImage(selectedImageFile!);
        if (uploadedUrl != null) {
          finalImageUrl = uploadedUrl;
        }
      }

      EditProfileModel profileModel = EditProfileModel(
        name: nameController.text.trim(),
        email: mailController.text.trim(),
        phone: phoneController.text.trim(),
        dob: dobController.text.trim(),
        profileImage: finalImageUrl ?? '',
      );

      await _repository.updateProfile(uid, profileModel);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Error updating profile: $e");
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.dispose();
  }
}