// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:DentaCarts/screen/details_produc_screen.dart';
import 'package:DentaCarts/screen/instruments_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/product_api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, dynamic>> categories = [
    {
      'icon': Icons.local_hospital,
      'label': 'Perio & Surgery',
    },
    {
      'icon': Icons.build,
      'label': 'Instruments',
    },
    {
      'icon': Icons.medical_services,
      'label': 'Consumables',
    },
    {
      'icon': Icons.healing,
      'label': 'Implant',
    },
    {
      'icon': Icons.local_hospital,
      'label': 'Perio & Surgery',
    },
    {
      'icon': Icons.build,
      'label': 'Instruments',
    },
    {
      'icon': Icons.medical_services,
      'label': 'Consumables',
    },
    {
      'icon': Icons.healing,
      'label': 'Implant',
    },
    {
      'icon': Icons.local_hospital,
      'label': 'Perio & Surgery',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Search ....",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
            SizedBox(height: 20),
            BannerSection(),
            SizedBox(height: 20),
            Text("Categories",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            CategorySection(categories: categories),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("On Sale",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => InstrumentsScreen()),
                    );
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            SaleProductsList(),
          ],
        ),
      ),
    );
  }
}

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(height: 35),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Color(0xFFFDE9E8),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dental Link Offers",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Get 20% OFF on MH Group Products.",
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: screenWidth * -0.07,
                bottom: screenHeight * -0.02,
                child: Image.asset(
                  'assets/images/banner.png',
                  height: 240,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CategorySection extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF8B0000),
                  radius: 25,
                  child: Icon(
                    category['icon'],
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(height: 5),
                Text(category['label']!,
                    style: GoogleFonts.poppins(fontSize: 12)),
              ],
            ),
          );
        },
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
      if (updatedStatus != null) {
        setState(() {
          isWishlisted = updatedStatus;
        });
      }
    } catch (e) {
      print("Error: Exception: Error toggling wishlist: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return DetailsProductPage();
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
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    Icons.star,
                                    color: index < widget.product.rating
                                        ? Colors.yellow
                                        : Colors.grey,
                                    size: 16,
                                  ),
                                ),
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
                  Container(
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
  const SaleProductsList({Key? key}) : super(key: key);

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
      physics: NeverScrollableScrollPhysics(),
      itemCount: _products.length > 3 ? 3 : _products.length,
      itemBuilder: (context, index) {
        return SaleProductCard(product: _products[index]);
      },
    );
  }
}
