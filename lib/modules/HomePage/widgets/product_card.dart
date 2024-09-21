import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String price;

  const ProductCard({required this.name, required this.price, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Image.asset(
              'assets/prod.jpeg',
              height: 100,
            ),
            const Spacer(),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$$price',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
