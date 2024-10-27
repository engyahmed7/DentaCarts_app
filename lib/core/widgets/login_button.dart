import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? child; 

  const LoginButton({
    super.key,
    required this.text, 
    this.child,
    required this.onPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child ?? Text(text), 
    );
  }
}
