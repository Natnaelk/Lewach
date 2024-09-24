import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lewach/controller/dashboard_controller.dart';
import 'package:lewach/view/screens/dashboard_screen.dart';
import 'package:lewach/view/screens/sign_in_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(DashboardController());

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dashboardController.changeIndex(0);
              return const DashboardScreen(
                pageIndex: 0,
              );
            } else {
              return const SignInPage();
            }
          }),
    );
  }
}
