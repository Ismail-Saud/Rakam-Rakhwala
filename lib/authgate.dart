import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/pages/homepage.dart';
import 'package:expensetracker/pages/loginpage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashLogoScreen();
        } else if (snapshot.hasData) {
          return HomePage(); // user is logged in
        } else {
          return LogIn(); // user is not logged in
        }
      },
    );
  }
}

class SplashLogoScreen extends StatelessWidget {
  const SplashLogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5D8),
      body: Center(
        child: Image.asset(
          'assets/1.png',
          width: 150,
        ),
      ),
    );
  }
}
