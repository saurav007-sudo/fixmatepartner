import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/auth model.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmail(String email, String password) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return credential.user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return credential.user;
  }

  Future<void> savePartnerToFirestore(String uid, AuthModel authModel) async {
    await FirebaseFirestore.instance.collection("partners").doc(uid).set(
      authModel.toMap(FieldValue.serverTimestamp()),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();

    final googleUser = await googleSignIn.authenticate();
    if (googleUser == null) return null;

    final clientAuth = await googleUser.authorizationClient.authorizeScopes(['email', 'profile']);

    final credential = GoogleAuthProvider.credential(
      idToken: googleUser.authentication.idToken,
      accessToken: clientAuth.accessToken,
    );

    UserCredential userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }
}