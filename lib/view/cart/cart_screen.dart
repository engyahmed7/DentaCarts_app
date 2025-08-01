import 'dart:convert';

import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/model/cart_model.dart';
import 'package:DentaCarts/view/details_product/details_produc_screen.dart';
import 'package:DentaCarts/view/payment/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Products",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            child: FutureBuilder<List<CartModel>?>(
              future: getCarts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading Cart ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No Cart available'));
                } else {
                  List<CartModel>? cartModel = snapshot.data;
                  final total = cartModel?.fold<double>(
                    0, (sum, item) => sum + double.tryParse(item.price)!,
                  );

                  if (cartModel!.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.asset('assets/images/cart_empty.png'),
                          ),
                        ),
                        totalRow(total),
                        checkoutButton(context, cartModel),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          itemCount: cartModel.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => DetailsProductPage(
                                    id: int.parse(cartModel[index].productId),
                                  ),
                                ));
                              },
                              child: Stack(
                                children: [
                                  Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: SizedBox(
                                      height: 150,
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              bottomLeft: Radius.circular(12),
                                            ),
                                            child: Image.network(
                                              "${AppStrings.marwanHoo}",
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Row(
                                                        children: List.generate(
                                                          5,
                                                              (index) => const Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                            size: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      const Text("|"),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        "${cartModel[index].stock} +",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    "${cartModel[index].name}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "${cartModel[index].price}",
                                                            style: const TextStyle(
                                                              color: AppColors.primaryColor,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    padding: const EdgeInsets.all(12),
                                                    margin: const EdgeInsets.only(right: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.pink.shade50,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Icon(
                                                      Icons.add_shopping_cart,
                                                      color: AppColors.primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    bool? confirmed = await showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: const Text('Remove Item'),
                                                        content: const Text(
                                                          'Are you sure you want to remove this item from your cart?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(false),
                                                            child: const Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(true),
                                                            child: const Text('Delete'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                    if (confirmed == true) {
                                                      await removeCart(
                                                        productId: cartModel[index].productId,
                                                        context: context,
                                                      );
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(12),
                                                    margin: const EdgeInsets.only(right: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.pink.shade50,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.favorite_border,
                                          color: AppColors.primaryColor,
                                        ),
                                        iconSize: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      totalRow(total),
                      checkoutButton(context, cartModel),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Row showing total price
  Widget totalRow(double? total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Total",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          "${total?.toStringAsFixed(2) ?? '0.00'} EGP",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Checkout Button always visible
  Widget checkoutButton(BuildContext context, List<CartModel> cartModel) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (cartModel.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Cart Is Empty")),
                );
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const PaymentScreen()));
              }
            },
            child: Text(
              "Checkout",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            heroTag: "refreshCartBtn",
            onPressed: () {
              setState(() {});
            },
            child: const Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }
}

Future<List<CartModel>> getCarts() async {
  final response = await http.get(
    Uri.parse('${AppStrings.baseUrl}/api/cart'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppStrings.token}',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return CartModel.listFromJson(data['items']);
  } else {
    return [];
  }
}

Future<void> removeCart({
  required String productId,
  required BuildContext context,
}) async {
  final response = await http.delete(
    Uri.parse('${AppStrings.baseUrl}/api/cart/$productId'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppStrings.token}',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
  } else {
    final data = json.decode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['error'])));
  }
}
