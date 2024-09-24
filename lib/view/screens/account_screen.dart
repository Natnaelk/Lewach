import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? currentUser;
  UserController? userController;
  @override
  void initState() {
    userController = Get.find<UserController>();
    super.initState();
  }

  // void logout() {
  //   FirebaseAuth.instance.signOut();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.lightGreen),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(() => Column(
                children: [
                  Text('${userController!.userEmail.value}',
                      style: TextStyle(fontSize: 25)),
                ],
              )),
          const SizedBox(
            height: 30,
          ),
          TextButton(
              onPressed: () => userController!.logout(),
              child: const Text('Log out'))
        ],
      ),
    );
  }
}
