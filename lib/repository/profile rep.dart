import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/profile ser.dart';

class ProfileRepository {
  final ProfileServices _services = ProfileServices();

  Stream<DocumentSnapshot> getPartnerProfile(String uid) {
    return _services.getPartnerProfileStream(uid);
  }

  Future<void> signOut(BuildContext context) async {
    await _services.signOutUser(context);
  }
}