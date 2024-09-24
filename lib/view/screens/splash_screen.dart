import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lewach/helper/colors.dart';
import 'package:lewach/view/screens/home_screen.dart';
import 'package:lewach/view/screens/sign_in_page.dart';
import 'package:lewach/view/screens/sign_up_screen.dart';
import 'package:lewach/view/widgets/common_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Lewach',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Center(
              child: Text(
                'Digitalizing the Traditional Ethiopian Product Exchange',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: [
                CommonButton(
                  onPressed: () {
                    Get.to(const SignInPage());
                  },
                  child: const Text('Next'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
