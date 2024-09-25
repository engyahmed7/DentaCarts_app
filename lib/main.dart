import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/HomePage/homepage.dart';
import 'package:flutter_application_1/modules/layout_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DentaCarts',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const LayoutScreen(),
    );
  }
}
