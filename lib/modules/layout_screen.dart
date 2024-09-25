import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/HomePage/homepage.dart';
import 'package:flutter_application_1/modules/admin/product-page.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return ProductAdminPanel();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return const HomePage();
        } else {
          return const HomePage();
        }
      },
    );
  }
}
