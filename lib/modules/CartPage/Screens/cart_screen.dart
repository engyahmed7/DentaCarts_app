import 'dart:convert';

import 'package:DentaCarts/constants/app_exports.dart';
import 'package:flutter/material.dart';
import 'package:DentaCarts/core/widgets/product_card.dart';
import 'package:DentaCarts/modules/PaymentGetway/payment_getway_screen.dart';
import 'package:http/http.dart' as http;
import '../../../controller/Auth/auth_cubit.dart';

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
    final authCubit = BlocProvider.of<AuthCubit>(context);

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/cart/'),
        headers: {'Authorization': 'Bearer ${authCubit.token}'},
      );

      if (response.statusCode == 200) {
        debugPrint("Products fetched: ${response.body}");
        setState(() {
          products = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
  }

  Future<void> updateQty(int index, int newQty) async {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/cart/${products[index]['productId']}'),
        headers: {'Authorization': 'Bearer ${authCubit.token}'},
        body: json.encode({
          'qty': newQty,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("Quantity updated for product: ${products[index]['productId']}");
      } else {
        throw Exception('Failed to update product quantity');
      }
    } catch (e) {
      debugPrint("Error updating product quantity: $e");
    }
  }

  Future<void> removeProduct(int index) async {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/cart/${products[index]['productId']}'),
        headers: {'Authorization': 'Bearer ${authCubit.token}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          products.removeAt(index);
        });
        debugPrint("Product removed from cart");
      } else {
        throw Exception('Failed to remove product');
      }
    } catch (e) {
      debugPrint("Error removing product: $e");
    }
  }

  double calculateTotalPrice() {
    double total = 0;
    for (var product in products) {
      total += product['price'] * product['qty'];
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
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ProductCard(
                    cartDesign: true,
                    name: products[index]['name'],
                    price: products[index]['price'].toString(),
                    imageUrl: products[index]['img'],
                    prodId: products[index]['productId'],
                    qty: products[index]['qty'],
                    onIncrement: () {
                      setState(() {
                        products[index]['qty']++;
                      });
                      updateQty(index, products[index]['qty']);
                    },
                    onDecrement: () {
                      setState(() {
                        if (products[index]['qty'] > 1) {
                          products[index]['qty']--;
                        }
                      });
                      updateQty(index, products[index]['qty']);
                    },
                    onRemove: () {
                      removeProduct(index);
                    },
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PaymentGetawayScreen()));
            },
            child: Text(
              "CHECKOUT   \$${totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
