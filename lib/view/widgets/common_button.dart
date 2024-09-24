import 'package:flutter/material.dart';
import 'package:lewach/helper/colors.dart';

class CommonButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  const CommonButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MyColors.primary.withOpacity(0.5),
              MyColors.primary,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
