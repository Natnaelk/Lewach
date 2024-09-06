import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lewach/helper/colors.dart';
import 'package:lewach/view/screens/home_screen.dart';
import 'package:lewach/view/screens/sign_in_page.dart';
import 'package:lewach/view/screens/sign_up_screen.dart';
import 'package:lewach/view/widgets/common_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Lewach',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                'Digitalizing the Traditional Ethiopian Product Exchange',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                CommonButton(
                  onPressed: () {
                    Get.to(SignInPage());
                  },
                  child: Text('Next'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
