
import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:DentaCarts/services/cart_api_service.dart';
import 'package:DentaCarts/view/details_produc_screen.dart';
import 'package:DentaCarts/view/home/banner_section.dart';
import 'package:DentaCarts/view/home/category_section.dart';
import 'package:DentaCarts/view/instruments_screen.dart';
import 'package:DentaCarts/viewmodel/cart/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../admin/services/product_api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // TextField(
            //   decoration: InputDecoration(
            //     hintText: "Search ....",
            //     prefixIcon: Icon(Icons.search),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10),
            //       borderSide: BorderSide.none,
            //     ),
            //     filled: true,
            //     fillColor: Colors.grey.shade200,
            //   ),
            // ),
            const SizedBox(height: 20),
            const BannerSection(),
            const SizedBox(height: 20),
            Text("Categories",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            CategorySection(categories: categoriesMap),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("On Sale",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const InstrumentsScreen()),
                    );
                  },
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const SaleProductsList(),
          ],
        ),
      ),
    );
  }
}





class SaleProductCard extends StatefulWidget {
  final Product product;

  const SaleProductCard({super.key, required this.product});

  @override
  _SaleProductCardState createState() => _SaleProductCardState();
}

class _SaleProductCardState extends State<SaleProductCard> {
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    checkWishlistStatus();
  }

  Future<void> checkWishlistStatus() async {
    print("Checking wishlist status for product: ${widget.product.id}");
    bool status =
        await ProductApiService().checkIfWishlisted(widget.product.id);
    print("Wishlist status for product ${widget.product.id}: $status");
    setState(() {
      isWishlisted = status;
    });
  }

  void toggleWishlist() async {
    try {
      bool? updatedStatus =
          await ProductApiService().toggleWishlist(widget.product.id);
      setState(() {
        isWishlisted = updatedStatus;
      });
    } catch (e) {
      print("Error: Exception: Error toggling wishlist: $e");
    }
  }

  void addToCart() async {
    try {
      final response = await CartApiService().addToCart(widget.product.id, 1);

      final item = {
        'productId': widget.product.id,
        'name': widget.product.title,
        'price': widget.product.price.toDouble(),
        'image': widget.product.images.isNotEmpty
            ? widget.product.images.first
            : 'assets/images/placeholder.png',
        'rating': widget.product.rating,
        'reviews': widget.product.reviews.toString(),
        'qty': 1,
      };

      context.read<CartCubit>().addItem(item);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item added to cart successfully!"),
          backgroundColor: Color.fromARGB(255, 30, 68, 31),
        ),
      );
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains("Out of stock")) {
        errorMessage = "${widget.product.title} is out of stock";
      } else {
        errorMessage = "Failed to add item to cart";
      }

      print("Error: $errorMessage");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.primaryColor,
        ),
      );
    }
  }

  // void addToCart() async {
  //   try {
  //     final response = await CartApiService().addToCart(widget.product.id, 1);
  //     print("Cart Response: $response");

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: const Text("Item added to cart successfully!"),
  //         backgroundColor: const Color.fromARGB(255, 30, 68, 31),
  //       ),
  //     );
  //   } catch (e) {
  //     String errorMessage = e.toString();

  //     if (errorMessage.contains("Out of stock")) {
  //       errorMessage = "${widget.product.title} is out of stock";
  //     } else {
  //       errorMessage = "Failed to add item to cart";
  //     }

  //     print("Error: $errorMessage");

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(errorMessage),
  //         backgroundColor: AppColors.primaryColor,
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return DetailsProductPage(
            product: widget.product,
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
                      widget.product.images.isNotEmpty
                          ? widget.product.images.first
                          : 'https://via.placeholder.com/100',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              FutureBuilder<double>(
                                future: ProductApiService()
                                    .fetchAverageRating(widget.product.id),
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
                              const SizedBox(width: 5),
                              Text(
                                "${widget.product.rating}+",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.product.title,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.product.description,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "\$${widget.product.price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "\$${(widget.product.price * 0.8).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  "30% OFF",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: addToCart,
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
                onPressed: toggleWishlist,
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? Colors.red : AppColors.primaryColor,
                ),
                iconSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SaleProductsList extends StatefulWidget {
  const SaleProductsList({super.key});

  @override
  _SaleProductsListState createState() => _SaleProductsListState();
}

class _SaleProductsListState extends State<SaleProductsList> {
  final ProductApiService _apiService = ProductApiService();
  List<Product> _products = [];
  bool _isLoading = true;
  String _error = "";

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final productList = await _apiService.fetchProducts();
      if (productList.isEmpty) {
        setState(() {
          _error = "No products found.";
          _isLoading = false;
        });
        return;
      }
      print(productList);
      setState(() {
        _products = productList.map((json) => Product.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load products.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(child: Text(_error));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _products.length > 3 ? 3 : _products.length,
      itemBuilder: (context, index) {
        return SaleProductCard(product: _products[index]);
      },
    );
  }
}
