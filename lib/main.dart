import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/layout/layout_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      home: LayoutScreen(),
    );
  }
}
