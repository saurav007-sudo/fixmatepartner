import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../models/editpersonal model.dart';

class EditProfileServices {
  final CollectionReference partnersRef = FirebaseFirestore.instance.collection('partners');

  Future<DocumentSnapshot> fetchUserDoc(String uid) async {
    return await partnersRef.doc(uid).get();
  }

  Future<String?> uploadImageToSupabase(XFile imageFile) async {
    try {
      final supabase = Supabase.instance.client;
      String timestamp = DateTime.now().microsecondsSinceEpoch.toString();
      String filePath = 'profile_images/$timestamp.jpg';

      if (kIsWeb) {
        Uint8List fileBytes = await imageFile.readAsBytes();
        await supabase.storage.from('fixmate').uploadBinary(
          filePath,
          fileBytes,
          fileOptions: FileOptions(cacheControl: '3600', upsert: true),
        );
      } else {
        File file = File(imageFile.path);
        await supabase.storage.from('fixmate').upload(
          filePath,
          file,
          fileOptions: FileOptions(cacheControl: '3600', upsert: true),
        );
      }

      return supabase.storage.from('fixmate').getPublicUrl(filePath);
    } catch (e) {
      debugPrint("Supabase profile image upload error: $e");
      return null;
    }
  }

  Future<void> updateProfileInFirestore(String uid, EditProfileModel profileModel) async {
    await partnersRef.doc(uid).set(profileModel.toMap(), SetOptions(merge: true));
  }
}