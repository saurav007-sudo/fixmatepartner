import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/government model.dart';

class GovernmentIdServices {
  final CollectionReference partnersRef = FirebaseFirestore.instance.collection('partners');

  Future<String?> uploadImageToSupabase(XFile imageFile) async {
    try {
      final supabase = Supabase.instance.client;
      String timestamp = DateTime.now().microsecondsSinceEpoch.toString();
      String fileName = 'id_$timestamp.jpg';
      String filePath = 'id_images/$fileName';

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

      final String publicUrl = supabase.storage
          .from('fixmate')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      debugPrint("Supabase upload error: $e");
      return null;
    }
  }

  Future<void> submitIdToFirestore(String uid, GovernmentIdModel model) async {
    await partnersRef.doc(uid).set(model.toMap(), SetOptions(merge: true));
  }
}