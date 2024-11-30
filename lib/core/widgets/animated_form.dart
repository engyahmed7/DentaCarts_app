import 'package:flutter/material.dart';
import 'package:DentaCarts/Layout/layout_modules.dart';
import 'package:DentaCarts/controller/Auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_button.dart';
import 'text_field.dart';

class AnimatedForm extends StatefulWidget {
  bool isExistingUser;
  final Animation<double> animation;

  AnimatedForm({
    super.key,
    required this.isExistingUser,
    required this.animation,
  });

  @override
  _AnimatedFormState createState() => _AnimatedFormState();
}

class _AnimatedFormState extends State<AnimatedForm> {
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController registerNameController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool showLoginPassword = false;
  bool showRegisterPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Padding(
        key: ValueKey<bool>(widget.isExistingUser),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: widget.isExistingUser
                ? _buildLoginForm(authCubit)
                : _buildRegisterForm(authCubit),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLoginForm(authCubit) {
    return [
      const SizedBox(height: 30),
      CustomTextField("Email Address", Icons.email, false,
          controller: loginEmailController),
      const SizedBox(height: 10),
      CustomTextField(
        "Password",
        Icons.lock,
        !showLoginPassword,
        controller: loginPasswordController,
        suffixIcon: IconButton(
          icon:
              Icon(showLoginPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              showLoginPassword = !showLoginPassword;
            });
          },
        ),
      ),
      const SizedBox(height: 20),
      LoginButton(
        text: "LOGIN",
        onPressed: isLoading
            ? () {}
            : () => authCubit.loginUser(
                  loginEmailController,
                  loginPasswordController,
                  context,
                ),
        child: isLoading ? const CircularProgressIndicator() : null,
      ),
    ];
  }

  List<Widget> _buildRegisterForm(authCubit) {
    return [
      const SizedBox(height: 30),
      CustomTextField("Full Name", Icons.person, false,
          controller: registerNameController),
      const SizedBox(height: 10),
      CustomTextField("Email Address", Icons.email, false,
          controller: registerEmailController),
      const SizedBox(height: 10),
      CustomTextField(
        "Password",
        Icons.lock,
        !showRegisterPassword,
        controller: registerPasswordController,
        suffixIcon: IconButton(
          icon: Icon(
              showRegisterPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              showRegisterPassword = !showRegisterPassword;
            });
          },
        ),
      ),
      const SizedBox(height: 10),
      CustomTextField(
        "Confirm Password",
        Icons.lock,
        !showConfirmPassword,
        controller: confirmPasswordController,
        suffixIcon: IconButton(
          icon: Icon(
              showConfirmPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              showConfirmPassword = !showConfirmPassword;
            });
          },
        ),
      ),
      const SizedBox(height: 20),
      LoginButton(
        text: "REGISTER",
        onPressed: isLoading
            ? null
            : () => authCubit.registerUser(
                  registerPasswordController,
                  confirmPasswordController,
                  registerNameController,
                  registerEmailController,
                  context,
                ),
        child: isLoading ? const CircularProgressIndicator() : null,
      ),
    ];
  }
}
