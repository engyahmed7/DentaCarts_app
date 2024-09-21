import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;

  const SectionHeader(
      {required this.title, required this.actionLabel, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            actionLabel,
            style: const TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
