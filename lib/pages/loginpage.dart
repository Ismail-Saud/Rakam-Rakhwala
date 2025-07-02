import 'package:expensetracker/pages/firebase_auth.dart';
import 'package:expensetracker/pages/homepage.dart';
import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Loginpage());
  }
}

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});
  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    try {
      await authService.value.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      // Show error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: ${e.toString()}")));
    }
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "SignIn",
              style: TextStyle(fontSize: 100, color: Color(0xFF321B15)),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 300,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 10.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                controller: passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: "Password",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 10.0,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    signIn();
                  },
                  child: Text("Sign-In"),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/signup");
                  },
                  child: Text("Sign up instead"),
                ),
              ],
            ),
            SizedBox(height: 20,),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     shape: const CircleBorder(),
            //     padding: const EdgeInsets.all(12),
            //     backgroundColor: Color(0xFF321B15),
            //     elevation: 4,
            //   ),
            //   onPressed: () async {
            //     final result = await authService.value.signInWithGoogle();
            //     if (result != null) {
            //       print("Signed in as ${result.user!.displayName}");
            //     } else {
            //       print("Google sign-in failed");
            //     }
            //   },
            //   child: Image.asset(
            //     'Search.png',
            //     width: 12,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
