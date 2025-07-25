import 'dart:convert';
import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/layout/layout_screen.dart';
import 'package:DentaCarts/model/wishlist_model.dart';
import 'package:DentaCarts/view/details_product/details_produc_screen.dart';
import 'package:DentaCarts/view/home/product_list_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text('Wishlist', style: GoogleFonts.poppins(color: Colors.black)),
      ),
      body: FutureBuilder<List<WishlistModel>?>(
        future: getWishList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading Cart ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No banner available'));
          } else {
            List<WishlistModel>? wishListModel = snapshot.data;
            if (wishListModel!.isEmpty) {
              return const EmptyWishlist();
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Row(
                    children: [
                      FilterButton(label: 'All', isSelected: true),
                      FilterButton(label: 'Perio & Surgery'),
                      FilterButton(label: 'Instruments'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return DetailsProductPage(
                                id: wishListModel[index].id,
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
                                        child: Image.network(
                                            "${AppStrings.marwanHoo}"
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                    "${wishListModel[index].stock} +",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                "${wishListModel[index].name}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              // Text(
                                              //   wishListModel[index].description,
                                              //   style: GoogleFonts.poppins(
                                              //     fontSize: 12,
                                              //     color: Colors.grey,
                                              //   ),
                                              //   maxLines: 3,
                                              //   overflow: TextOverflow.ellipsis,
                                              // ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                        "${wishListModel[index].price}",
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                      // GestureDetector(
                                      //   onTap: () {},
                                      //   child: Container(
                                      //     padding: const EdgeInsets.all(12),
                                      //     margin:
                                      //         const EdgeInsets.only(right: 10),
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.pink.shade50,
                                      //       borderRadius:
                                      //           BorderRadius.circular(8),
                                      //     ),
                                      //     child: const Icon(
                                      //       Icons.add_shopping_cart,
                                      //       color: AppColors.primaryColor,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   top: 8,
                              //   left: 8,
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       shape: BoxShape.circle,
                              //       boxShadow: [
                              //         BoxShadow(
                              //           color: Colors.black.withOpacity(0.1),
                              //           blurRadius: 4,
                              //           offset: const Offset(0, 2),
                              //         ),
                              //       ],
                              //     ),
                              //     child: IconButton(
                              //       onPressed: () async{
                              //         // await toggleWishlist(productId:  wishListModel[index].id, context: context);
                              //         // setState(() {
                              //         //
                              //         // });
                              //       },
                              //       icon:  const Icon(
                              //         //isWishlisted ? Icons.favorite : Icons.favorite_border,
                              //         //color: isWishlisted ? Colors.red : AppColors.primaryColor,
                              //         Icons.favorite_border,
                              //         color: AppColors.primaryColor,
                              //       ),
                              //       iconSize: 24,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      },
                      itemCount: wishListModel!.length,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Future<List<WishlistModel>> getWishList() async {
  final response = await http.get(
    Uri.parse('${AppStrings.baseUrl}/api/wishlist'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppStrings.token}',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return WishlistModel.listFromJson(data);
  } else {
    return [];
  }
}


class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const FilterButton({super.key, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primaryColor : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () {},
        child: Text(label),
      ),
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Icon(Icons.favorite_border,
                  size: 80, color: AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Wishlist is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LayoutScreen()),
                (route) => false,
              );
            },
            child: const Text('Return to shop',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
