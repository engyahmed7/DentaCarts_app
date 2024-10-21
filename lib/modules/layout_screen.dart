import 'package:flutter/material.dart';
import 'package:flutter_application_1/Layout/layout_modules.dart';
import 'package:flutter_application_1/modules/Login/Screens/login_screen.dart';
import 'package:flutter_application_1/modules/admin/admin_login.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return const AdminAuthApp();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return const LoginScreen();
        } else {
          return  const LoginScreen();
        }
      },
    );
  }
}
