import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/product_card.dart';
import 'package:flutter_application_1/modules/PaymentGetway/payment_getway_screen.dart';
import 'package:http/http.dart' as http;
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
      await http.get(Uri.parse('https://dummyjson.com/products'));
      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body)['products'];
        });
        // debugPrint("Products fetched: $products");
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
  }

  double calculateTotalPrice() {
    double total = 0;
    for (var product in products) {
      total += product['price'];
    }
    return total;
  }
  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    double totalPrice = calculateTotalPrice();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ProductCard(
                    cartDesign: true,
                    name: products[index]['title'],
                    price: products[index]['price'].toString(),
                    imageUrl: products[index]['thumbnail'],
                  ),
                );
              },
            ),
          ),
          const Divider(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 70),
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const PaymentGetawayScreen()));
            },
            child:  Text(
              "CHECKOUT   \$${totalPrice.toStringAsFixed(2)}", // Display the total price here
              style: const TextStyle(
              color: Colors.white,
            ),),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
