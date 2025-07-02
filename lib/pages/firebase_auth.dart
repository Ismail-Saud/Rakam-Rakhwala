import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }

  // Future<void> resetPassword({required String email}) async {
  //   return await firebaseAuth.sendPasswordResetEmail(email: email);
  // }

  // Future<void> updateUsername({required String username}) async {
  //   return await currentUser!.updateDisplayName(username);
  // }

  // Future<void> resetPasswordfromCurrentPassword({
  //   required String email,
  //   required String currentPassword,
  //   required String newPassword,
  // }) async {
  //   AuthCredential credential = EmailAuthProvider.credential(
  //     email: email,
  //     password: currentPassword,
  //   );
  //   await currentUser!.reauthenticateWithCredential(credential);
  //   await currentUser!.updatePassword(newPassword);
  // }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Google sign-in error: $e");
      return null;
    }
  }


}
