import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get/route_manager.dart';
import 'package:lewach/view/screens/dashboard_screen.dart';
import 'package:lewach/view/screens/sign_in_page.dart';
import 'package:lewach/view/widgets/common_button.dart';
import 'package:lewach/view/widgets/common_textfield.dart';
import 'package:lewach/view/widgets/error_message.dart';

import '../../controller/user_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void registerUser() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    //validate the inputs
    if (_formKey.currentState!.validate()) {
      //try to create a user
      try {
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        User? user = userCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'email': user.email,
            'full_name': nameController.text.trim(),
            'phone_number': phoneController.text.trim(),
            'createdAt': Timestamp.now(),
          });
        }

        Get.find<UserController>().getUserData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully registered ')),
        );

        // pop loading circle

        Navigator.pop(context);
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        errorMessage(e.code, context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        // backgroundColor: ColorName.secondaryColor.withOpacity(0.3),
        // surfaceTintColor: ColorName.secondaryColor.withOpacity(0.3),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // ColorName.secondaryColor.withOpacity(0.3),
                  // ColorName.secondaryColor.withOpacity(0.5),
                  // ColorName.secondaryColor,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      color: Colors.black38,
                    ),
                    const SizedBox(height: 80),
                    _buildMiddle(),
                    const SizedBox(height: 150),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?",
                              style: Theme.of(context).textTheme.titleMedium),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'SIGN UP',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildMiddle() {
    return Column(
      children: [
        const Text(
          "Create New Account",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        CommonTextField(
          validator: (text) {
            if (text!.isEmpty) {
              return 'Full Name is Empty';
            }
            return null;
          },
          controller: nameController,
          hintText: 'Full Name',
        ),
        CommonTextField(
          validator: (text) {
            if (text!.isEmpty) {
              return 'Phone Number is Empty';
            } else if (!RegExp(r'^\d+$').hasMatch(text)) {
              return 'Phone Number should only contain numbers';
            } else if (text.length != 10) {
              return 'Phone Number must be 10 digits';
            }
            return null;
          },
          controller: phoneController,
          hintText: 'Phone Number',
        ),
        CommonTextField(
          validator: (text) {
            if (text!.isEmpty) {
              return 'Email is Empty';
            } else if (text.isEmail == false) {
              return 'Email is not valid';
            }
            return null;
          },
          controller: emailController,
          hintText: 'Email Address',
        ),
        CommonTextField(
          validator: (text) {
            if (text!.isEmpty) {
              return 'Password is Empty';
            } else if (text.length < 6) {
              return 'Password should be atleast 6 characters';
            }
            return null;
          },
          isObscure: true,
          controller: passwordController,
          hintText: 'Password',
        ),
        const SizedBox(height: 40),
        CommonButton(
          onPressed: registerUser,
          child: Text(
            'SIGN UP',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        )
      ],
    );
  }
}
