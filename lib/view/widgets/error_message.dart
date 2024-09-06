import 'package:flutter/material.dart';

void errorMessage(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(message),
          ));
}
