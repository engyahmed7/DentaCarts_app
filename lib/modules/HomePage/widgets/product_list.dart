import 'package:flutter/material.dart';
import 'product_card.dart';

class ProductList extends StatelessWidget {
  final bool onSale;

  const ProductList({
    super.key,
    required this.onSale,
  });

  @override
  Widget build(BuildContext context) {
    final products = [
      {'name': 'Surgical Scissors', 'price': '20', 'sale': true},
      {'name': 'Dental Mirror', 'price': '5', 'sale': true},
      {'name': 'Dental Mirror', 'price': '5', 'sale': true},
      {'name': 'Dental Mirror', 'price': '5', 'sale': true},
      {'name': 'Dental Mirror', 'price': '5', 'sale': true},
      {'name': 'Orthodontic Braces', 'price': '120', 'sale': false},
      {'name': 'Orthodontic Braces', 'price': '120', 'sale': false},
      {'name': 'Orthodontic Braces', 'price': '120', 'sale': false},
      {'name': 'Orthodontic Braces', 'price': '120', 'sale': false},
      {'name': 'Orthodontic Braces', 'price': '120', 'sale': false},
      {'name': 'Implant Screw', 'price': '300', 'sale': false},
    ];

    final filteredProducts =
        products.where((product) => product['sale'] == onSale).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ProductCard(
                name: product['name'] as String,
                price: product['price'] as String,
              ),
            );
          },
        ),
      ),
    );
  }
}
