import 'package:flutter/material.dart';
import 'login_button.dart';
import 'text_field.dart';

class AnimatedForm extends StatelessWidget {
  final bool isExistingUser;
  final Animation<double> animation;

  const AnimatedForm({
    super.key,
    required this.isExistingUser,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Padding(
        key: ValueKey<bool>(isExistingUser),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: isExistingUser ? _buildLoginForm() : _buildRegisterForm(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLoginForm() {
    return [
      const SizedBox(height: 30),
      const CustomTextField("Email Address", Icons.email, false),
      const SizedBox(height: 10),
      const CustomTextField("Password", Icons.lock, true),
      const SizedBox(height: 20),
      const LoginButton("LOGIN"),
      const SizedBox(height: 10),
      // TextButton(
      //   onPressed: () {
      //   },
      //   child: const Text(
      //     "Forgot Password?",
      //     style: TextStyle(color: Colors.grey),
      //   ),
      // ),
    ];
  }

  List<Widget> _buildRegisterForm() {
    return [
      const SizedBox(height: 30),
      const CustomTextField("Full Name", Icons.person, false),
      const SizedBox(height: 10),
      const CustomTextField("Email Address", Icons.email, false),
      const SizedBox(height: 10),
      const CustomTextField("Password", Icons.lock, true),
      const SizedBox(height: 10),
      const CustomTextField("Confirm Password", Icons.lock, true),
      const SizedBox(height: 20),
      const LoginButton("REGISTER"),
    ];
  }
}
