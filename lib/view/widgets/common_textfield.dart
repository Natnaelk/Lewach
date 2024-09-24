import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final String? Function(String? text)? validator;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        validator: (text) => validator?.call(text?.trim()),
        obscureText: isObscure,
        controller: controller,
        onChanged: (text) {
          controller.value = controller.value.copyWith(
            text: text.trim(),
            selection: TextSelection.fromPosition(
              TextPosition(offset: text.trim().length),
            ),
          );
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black38,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
