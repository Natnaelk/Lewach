import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lewach/view/screens/dashboard_screen.dart';
import 'package:lewach/view/screens/home_screen.dart';
import 'package:lewach/view/screens/sign_in_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const DashboardScreen();
            } else {
              return const SignInPage();
            }
          }),
    );
  }
}
