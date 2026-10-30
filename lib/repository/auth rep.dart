import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/auth model.dart';
import '../services/auth ser.dart';

class AuthRepository {
  final AuthServices _services = AuthServices();

  Future<User?> signUp(String email, String password) async {
    return await _services.signUpWithEmail(email, password);
  }

  Future<User?> signIn(String email, String password) async {
    return await _services.signInWithEmail(email, password);
  }

  Future<void> savePartnerData(String uid, AuthModel authModel) async {
    await _services.savePartnerToFirestore(uid, authModel);
  }

  Future<void> sendPasswordReset(String email) async {
    await _services.sendPasswordResetEmail(email);
  }

  Future<User?> signInWithGoogle() async {
    return await _services.signInWithGoogle();
  }
}