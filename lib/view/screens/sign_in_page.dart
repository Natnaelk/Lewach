import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lewach/helper/colors.dart';
import 'package:lewach/view/screens/dashboard_screen.dart';
import 'package:lewach/view/widgets/common_button.dart';
import 'package:lewach/view/widgets/common_textfield.dart';
import 'package:lewach/view/widgets/error_message.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void login() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    if (_formKey.currentState!.validate()) {
      //try to login
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());

        // pop loading circle
        // if (context.mounted) {
        //   Navigator.pop(context);
        // }
        Get.back();
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        errorMessage(e.code, context);
      }
    } else {
      print("form invalid");
      Navigator.pop(context);
    }
    Get.to(DashboardScreen());
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
            decoration: BoxDecoration(
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
                      'Sign In',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      color: Colors.black38,
                    ),
                    const SizedBox(height: 150),
                    _buildMiddle(),
                    const SizedBox(height: 150),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: TextButton(
                    //       onPressed: () {},
                    //       child: Text(
                    //         'Forget Your Passoword?',
                    //         style: Theme.of(context)
                    //             .textTheme
                    //             .titleMedium!
                    //             .copyWith(
                    //               color: Colors.black87,
                    //             ),
                    //       )),
                    // )
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
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(100),
        //   child: Assets.images.placeHolder.image(
        //     width: 120,
        //     height: 120,
        //   ),
        // ),
        const SizedBox(height: 20),
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
            }
            return null;
          },
          isObscure: true,
          controller: passwordController,
          hintText: 'Password',
        ),
        const SizedBox(height: 30),
        CommonButton(
          onPressed: login,
          child: Text(
            'SIGN IN',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),

        SizedBox(
          height: 150,
        ),
        GestureDetector(
            onTap: () async {
              // final pref = await SharedPreferences.getInstance();
              // // bool _isFirstOpen =
              // pref.setBool('isGuest', true);

              // Get.to(() => DashboardScreen(
              //       pageIndex: 0,
              //     ));
            },
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '${'Continue as'.tr} ',
                  style: TextStyle(color: Theme.of(context).disabledColor)),
              TextSpan(
                  text: 'Guest'.tr, style: TextStyle(color: MyColors.primary)),
            ]))),
      ],
    );
  }
}
