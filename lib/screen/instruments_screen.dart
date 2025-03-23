import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:flutter/material.dart';
import '../services/product_api_service.dart';

class InstrumentsScreen extends StatefulWidget {
  const InstrumentsScreen({super.key});

  @override
  _InstrumentsScreenState createState() => _InstrumentsScreenState();
}

class _InstrumentsScreenState extends State<InstrumentsScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    try {
      List<dynamic> rawProducts = await ProductApiService().fetchProducts();
      return rawProducts.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

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
            FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No products found"));
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

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

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
          const Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.favorite_border, color: AppColors.primaryColor),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Image.network(
                  product.images.isNotEmpty
                      ? product.images[0]
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
            product.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            product.category,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
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
                child: const Icon(Icons.shopping_cart_checkout_sharp,
                    color: AppColors.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
