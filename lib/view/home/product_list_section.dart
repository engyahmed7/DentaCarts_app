import 'dart:convert';

import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:DentaCarts/view/cart/cart_screen.dart';
import 'package:DentaCarts/view/details_product/details_produc_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SaleProductsList extends StatefulWidget {
  const SaleProductsList({super.key});

  @override
  _SaleProductsListState createState() => _SaleProductsListState();
}

class _SaleProductsListState extends State<SaleProductsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>?>(
      future: getProductsListInHomeScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading products'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No banner available'));
        } else {
          List<ProductModel>? productModel = snapshot.data;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              ProductModel product = productModel![index];

              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return  DetailsProductPage(
                      id: product.id,
                    );
                  }));
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
                              child: Image.network("${AppStrings.marwanHoo}"
                                  // widget.product.images.isNotEmpty
                                  //     ? widget.product.images.first
                                  //     : 'https://via.placeholder.com/100',
                                  // height: double.infinity,
                                  // width: 100,
                                  // fit: BoxFit.cover,
                                  ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: List.generate(
                                            5,
                                            (index) => const Icon(
                                              Icons.star,
                                              // color: index < avgRating.round()
                                              //     ? Colors.amber
                                              //     : Colors.grey,
                                              color: Colors.amber,

                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const Text("|"),
                                        const SizedBox(width: 5),
                                        Text(
                                          "${product.stock} +",
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
                                      "${productModel?[index].title}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      product.description,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //   // "\$${widget.product.price.toStringAsFixed(2)}",
                                            //   "text",
                                            //   style: TextStyle(
                                            //     decoration: TextDecoration.lineThrough,
                                            //     color: Colors.grey,
                                            //   ),
                                            // ),
                                            Text(
                                              "${product.price}",
                                              style: const TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Container(
                                        //   padding: const EdgeInsets.symmetric(
                                        //       horizontal: 6, vertical: 2),
                                        //   decoration: BoxDecoration(
                                        //     color: Colors.green,
                                        //     borderRadius: BorderRadius.circular(5),
                                        //   ),
                                        //   child: const Text(
                                        //     "30% OFF",
                                        //     style: TextStyle(
                                        //       color: Colors.white,
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async{
                                await addToCart(productId:  product.id, context: context);
                              },
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
                          onPressed: () async{
                            await toggleWishlist(productId:  product.id, context: context);

                          },
                          icon: const Icon(
                            //isWishlisted ? Icons.favorite : Icons.favorite_border,
                            //color: isWishlisted ? Colors.red : AppColors.primaryColor,
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
          );
        }
      },
    );
  }
}

Future<List<ProductModel>> getProductsListInHomeScreen() async {
  final response = await http.get(
    Uri.parse('${AppStrings.baseUrl}/api/products'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return ProductModel.listFromJson(data['products']);
  } else {
    return [];
  }
}

Future<void> toggleWishlist({required int productId,required BuildContext context}) async {
  final response = await http.post(
    Uri.parse('${AppStrings.baseUrl}/api/wishlist/toggle'),
    body: {"productId": "$productId"},
    headers: {
      'Accept': 'application/json',
      //'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppStrings.token}',
    },
  );
  final data = json.decode(response.body);
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${data['message']}")));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${data['message']}")));
  }
}


Future<void> addToCart({required int productId,required BuildContext context}) async {
  final response = await http.post(
    Uri.parse('${AppStrings.baseUrl}/api/cart'),
    body: jsonEncode({
      "productId": productId,
      "qty": 1
    }),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppStrings.token}',
    },
  );
  final data = json.decode(response.body);
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add To Cart Successfully")));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${data['message']}")));
  }
}