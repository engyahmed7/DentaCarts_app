import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:DentaCarts/services/cart_api_service.dart';
import 'package:DentaCarts/view/details_produc_screen.dart';
import 'package:DentaCarts/viewmodel/cart/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../admin/services/product_api_service.dart';

class InstrumentsScreen extends StatefulWidget {
  const InstrumentsScreen({super.key});

  @override
  _InstrumentsScreenState createState() => _InstrumentsScreenState();
}

class _InstrumentsScreenState extends State<InstrumentsScreen> {
  late Future<List<Product>> futureProducts;
  List<String> categories = [];
  String selectedCategory = 'all';
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureProducts = Future.value([]);
    _loadInitialData();
  }

  void _loadInitialData() async {
    categories = (await ProductApiService().fetchCategories()).cast<String>();
    print("Categories: $categories");

    setState(() {
      futureProducts = _fetchProducts();
    });
  }

  Future<List<Product>> _fetchProducts() async {
    try {
      List<dynamic> rawProducts;

      if (searchQuery.isNotEmpty) {
        rawProducts = await ProductApiService().searchProducts(searchQuery);
      } else if (selectedCategory == 'all') {
        rawProducts = await ProductApiService().fetchProducts();
      } else {
        rawProducts =
            await ProductApiService().fetchProductsByCategory(selectedCategory);
      }

      return rawProducts.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  // Future<List<Product>> _fetchProducts() async {
  //   try {
  //     List<dynamic> rawProducts = await ProductApiService().fetchProducts();
  //     return rawProducts.map((json) => Product.fromJson(json)).toList();
  //   } catch (e) {
  //     print("Error: $e");
  //     return [];
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Instruments', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  futureProducts = _fetchProducts();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search ...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.filter_list),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),
            if (categories.isNotEmpty)
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    String category =
                        index == 0 ? 'all' : categories[index - 1];
                    bool isSelected = selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(category.toUpperCase()),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                            futureProducts = _fetchProducts();
                          });
                        },
                        selectedColor: AppColors.primaryColor,
                        backgroundColor: AppColors.secondaryColor,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                            child: Icon(Icons.error_sharp,
                                size: 80, color: AppColors.primaryColor),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Products Found',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Please try again later. Stay tuned for updates!",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final products = snapshot.data!;
                return Expanded(
                  child: GridView.builder(
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
    if (!mounted) return;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 1),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: toggleWishlist,
              icon: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: isWishlisted ? Colors.red : AppColors.primaryColor,
              ),
              iconSize: 24,
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsProductPage(
                                product: widget.product,
                              )));
                },
                child: Image.network(
                  widget.product.images.isNotEmpty
                      ? widget.product.images[0]
                      : 'assets/images/medical.png',
                  fit: BoxFit.contain,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/medical.png',
                        height: 100);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            widget.product.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            widget.product.category,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            '\$${widget.product.price.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GestureDetector(
                  onTap: addToCart,
                  child: const Icon(
                    Icons.add_shopping_cart,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
