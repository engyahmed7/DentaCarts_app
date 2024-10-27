import 'package:flutter/material.dart';
import 'package:flutter_application_1/Layout/layout_modules.dart';
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

  Future<void> registerUser() async {
    if (registerPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": registerNameController.text,
          "email": registerEmailController.text,
          "password": registerPasswordController.text,
          "gender": "male",
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Registered Successfully. Please login.",
              style: TextStyle(color: Colors.green),
            ),
          ),
        );
        setState(() {
          widget.isExistingUser = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration Failed: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": loginEmailController.text,
          "password": loginPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Logged in Successfully",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LayoutModules()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Failed: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                ? _buildLoginForm()
                : _buildRegisterForm(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLoginForm() {
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
        onPressed: isLoading ? () {} : loginUser,
        child: isLoading ? const CircularProgressIndicator() : null,
      ),
    ];
  }

  List<Widget> _buildRegisterForm() {
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
        onPressed: isLoading ? null : registerUser,
        child: isLoading ? const CircularProgressIndicator() : null,
      ),
    ];
  }
}
