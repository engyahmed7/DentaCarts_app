import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/blocs/cart/cart_cubit.dart';
import 'package:DentaCarts/blocs/cart/cart_state.dart';
import 'package:DentaCarts/screen/instruments_screen.dart';
import 'package:DentaCarts/screen/payment_screen.dart';
import 'package:DentaCarts/services/cart_api_service.dart';
import 'package:DentaCarts/admin/services/product_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCartData();
  }

  Future<void> fetchCartData() async {
    try {
      List<dynamic> response = await CartApiService().fetchCart();
      setState(() {
        cartItems = response
            .map((item) => {
                  'productId': item['productId'] ?? '1',
                  'name': item['name'] ?? 'Unknown',
                  'price': (item['price'] ?? 0).toDouble(),
                  'image': item['img'] ?? 'assets/images/medical.png',
                  'rating': (item['rating'] ?? 5.0).toDouble(),
                  'reviews': item['reviews']?.toString() ?? "0",
                  'qty': (item['qty'] ?? 1),
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void updateQuantity(int index, int change) {
    setState(() {
      cartItems[index]['qty'] = (cartItems[index]['qty'] + change).clamp(1, 99);
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   double totalPrice =
  //       cartItems.fold(0, (sum, item) => sum + (item['price'] * item['qty']));

  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.white,
  //       elevation: 0,
  //       title: Text("Your Products",
  //           style: GoogleFonts.poppins(color: Colors.black)),
  //       actions: [
  //         Padding(
  //           padding: const EdgeInsets.only(right: 16),
  //           child: Center(
  //             child: Text(
  //               "${cartItems.length} Item(s)",
  //               style: GoogleFonts.poppins(
  //                   color: Colors.black, fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //     body: isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : errorMessage.isNotEmpty
  //             ? Center(
  //                 child: Text(errorMessage,
  //                     style: const TextStyle(color: Colors.red)))
  //             : Column(
  //                 children: [
  //                   Expanded(
  //                     child: ListView.builder(
  //                       itemCount: cartItems.length,
  //                       itemBuilder: (context, index) {
  //                         return CartItemCard(
  //                           item: cartItems[index],
  //                           onQuantityChanged: (change) =>
  //                               updateQuantity(index, change),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(16.0),
  //                     child: Column(
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text("TOTAL",
  //                                 style: GoogleFonts.poppins(
  //                                     fontSize: 18,
  //                                     fontWeight: FontWeight.bold)),
  //                             Text("\$${totalPrice.toStringAsFixed(2)}",
  //                                 style: GoogleFonts.poppins(
  //                                     fontSize: 18,
  //                                     fontWeight: FontWeight.bold)),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 10),
  //                         SizedBox(
  //                           width: double.infinity,
  //                           height: 50,
  //                           child: ElevatedButton(
  //                             style: ElevatedButton.styleFrom(
  //                               backgroundColor: AppColors.primaryColor,
  //                               shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(10)),
  //                             ),
  //                             onPressed: () {
  //                               Navigator.of(context).push(MaterialPageRoute(
  //                                   builder: (_) => const PaymentScreen()));
  //                             },
  //                             child: Text("Check out",
  //                                 style: GoogleFonts.poppins(
  //                                     fontSize: 18, color: Colors.white)),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //   );
  // }

  void deleteCartItem(String productId) async {
    try {
      await CartApiService().deleteCartItem(productId);
      setState(() {
        cartItems.removeWhere((item) => item['productId'] == productId);
      });
    } catch (e) {
      print("Error deleting item: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Your Products",
            style: GoogleFonts.poppins(color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "${cartItems.length} Item(s)",
                style: GoogleFonts.poppins(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          } else if (state is CartLoaded) {
            final cartItems = state.items;

            if (cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.shopping_cart,
                            size: 80, color: AppColors.primaryColor),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your Cart is empty',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "It's time to fill with amazing products!",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const InstrumentsScreen()),
                        );
                      },
                      child: const Text('Return to shop',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            final totalPrice = cartItems.fold(
                0.0, (sum, item) => sum + (item['price'] * item['qty']));

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItemCard(
                        item: cartItems[index],
                        onQuantityChanged: (change) {
                          context
                              .read<CartCubit>()
                              .updateQuantity(index, change);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("TOTAL",
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("\$${totalPrice.toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const PaymentScreen()));
                          },
                          child: Text("Check out",
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}

class CartItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function(int) onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
  });

  @override
  _CartItemCardState createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  void onQuantityChangedMethod(String productId, int newQuantity) async {
    print("Product ID: ${widget.item['productId']}");
    print("New Quantity: $newQuantity");
    if (newQuantity < 1) return;
    try {
      await CartApiService().updateCartQuantity(productId, newQuantity);
      setState(() {
        widget.item['qty'] = newQuantity;
      });
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  widget.item['image'],
                  height: double.infinity,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder<double>(
                            future: ProductApiService()
                                .fetchAverageRating(widget.item['productId']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                print("Error: ${snapshot.error}");
                                return const Text("Error loading rating");
                              } else {
                                double avgRating = snapshot.data!;
                                return Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      Icons.star,
                                      color: index < avgRating.round()
                                          ? Colors.amber
                                          : Colors.grey,
                                      size: 16,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<CartCubit>()
                                  .removeItemById(widget.item['productId']);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.item['name'],
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${widget.item['price']}",
                            style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          QuantitySelector(
                            quantity: widget.item['qty'],
                            onDecrease: () => onQuantityChangedMethod(
                                widget.item['productId'],
                                widget.item['qty'] - 1),
                            onIncrease: () => onQuantityChangedMethod(
                                widget.item['productId'],
                                widget.item['qty'] + 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onDecrease,
            icon: const Icon(Icons.remove,
                size: 18, color: AppColors.primaryColor),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4.0),
          ),
          const SizedBox(width: 15),
          Text(
            "$quantity",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 15),
          IconButton(
            onPressed: onIncrease,
            icon:
                const Icon(Icons.add, size: 18, color: AppColors.primaryColor),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4.0),
          ),
        ],
      ),
    );
  }
}
