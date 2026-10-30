import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';


import '../models/editpersonal model.dart';
import '../services/editpersonal ser.dart';

class EditProfileRepository {
  final EditProfileServices _services = EditProfileServices();

  Future<EditProfileModel?> getUserProfile(String uid) async {
    DocumentSnapshot doc = await _services.fetchUserDoc(uid);
    if (doc.exists && doc.data() != null) {
      return EditProfileModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<String?> uploadImage(XFile imageFile) async {
    return await _services.uploadImageToSupabase(imageFile);
  }

  Future<void> updateProfile(String uid, EditProfileModel profileModel) async {
    await _services.updateProfileInFirestore(uid, profileModel);
  }
}