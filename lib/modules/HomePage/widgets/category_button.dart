import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryButton({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.teal,
          child: Icon(icon, size: 30, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
