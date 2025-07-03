import 'dart:convert';

import 'package:DentaCarts/icons/my_flutter_app_icons.dart';
import 'package:DentaCarts/services/api_service.dart';
import 'package:DentaCarts/layout/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:DentaCarts/core/app_colors.dart';
import 'package:http/http.dart' as http;

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool obscureTextPassword = true;
  bool obscureTextConfirmPassword = true;

  String? _selectedGender;


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        // Responsive background circles
        Positioned(
          top: -screenHeight * 0.3,
          right: -screenWidth * 0.3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: screenWidth * 0.8,
                height: screenWidth * 0.8,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE9E8).withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: screenWidth * 1.05,
                height: screenWidth * 1.05,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFDE9E8).withOpacity(0.8),
                    width: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Text(
                      "Create Account",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.07, // responsive text
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Create an account so you can explore\nall Dental Supplies",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    // Username
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        filled: true,
                        fillColor: const Color(0xFFFDE9E8).withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Email
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        filled: true,
                        fillColor: const Color(0xFFFDE9E8).withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Password
                    TextField(
                      controller: passwordController,
                      obscureText: obscureTextPassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        filled: true,
                        fillColor: const Color(0xFFFDE9E8).withOpacity(0.4),
                        suffixIcon: IconButton(
                          icon: Icon(
                            !obscureTextPassword
                                ? MyFlutterApp.noun_eye_7539235
                                : MyFlutterApp.noun_eye_7555192,
                            color: Colors.black,
                            size: 27,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureTextPassword = !obscureTextPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Confirm Password
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: obscureTextConfirmPassword,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        filled: true,
                        fillColor: const Color(0xFFFDE9E8).withOpacity(0.4),
                        suffixIcon: IconButton(
                          icon: Icon(
                            !obscureTextConfirmPassword
                                ? MyFlutterApp.noun_eye_7539235
                                : MyFlutterApp.noun_eye_7555192,
                            color: Colors.black,
                            size: 27,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureTextConfirmPassword = !obscureTextConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Gender",
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.041,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'male',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                            title: const Text('Male'),
                            activeColor: AppColors.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'female',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                            title: const Text('Female'),
                            activeColor: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Responsive Signup Button, pass controllers/gender
                    SignupButton(
                      nameController: nameController,
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      gender: _selectedGender,
                    ),
                    SizedBox(height: screenHeight * 0.035),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Already have an account",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.045),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    ));
  }
}

class SignupButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? gender;

  const SignupButton({
    Key? key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          final name = nameController.text.trim();
          final email = emailController.text.trim();
          final password = passwordController.text;
          final confirmPassword = confirmPasswordController.text;

          if (name.isEmpty ||
              email.isEmpty ||
              password.isEmpty ||
              confirmPassword.isEmpty ||
              gender == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please fill all fields!')),
            );
            return;
          }

          if (password != confirmPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Passwords do not match!')),
            );
            return;
          }

          await signup(context, name, email, password, gender!);
        },
        child: Text(
          "Sign up",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

Future<void> signup(BuildContext context, String name, String email,
    String password, String gender) async {

    final response = await http.post(
      Uri.parse('https://server.dentallink.co/api/auth/signup'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "username": name,
        "password": password,
        "gender": gender,
      }),

    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {


      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('${data['msg']}')),
      );
      Navigator.of(context).pop();
    } else {

      String errorMsg = 'Signup failed';

      // Check for errors key and combine messages
      if (data['errors'] != null && data['errors'] is Map) {
        List<String> messages = [];
        data['errors'].forEach((key, value) {
          if (value is List) {
            messages.addAll(value.map((v) => v.toString()));
          } else {
            messages.add(value.toString());
          }
        });
        errorMsg = messages.join('\n');
      } else if (data['message'] != null) {
        errorMsg = data['message'].toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
}
