import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:DentaCarts/services/cart_api_service.dart';
import 'package:DentaCarts/services/product_api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

class DetailsProductPage extends StatefulWidget {
  final Product product;

  const DetailsProductPage({super.key, required this.product});

  @override
  _DetailsProductPageState createState() => _DetailsProductPageState();
}

class _DetailsProductPageState extends State<DetailsProductPage> {
  int selectedIndex = 0;
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
      print("Cart Response: $response");

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: toggleWishlist,
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.red : AppColors.primaryColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.product.images[selectedIndex],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.product.images.length,
                itemBuilder: (context, idx) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = idx;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedIndex == idx
                              ? Colors.red
                              : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.product.images[idx],
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      color: index < widget.product.rating.round()
                          ? Colors.yellow
                          : Colors.grey,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.product.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.product.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Read more',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  addToCart();
                },
                child: Text(
                  "Add to Cart",
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
