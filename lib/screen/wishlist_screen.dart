import 'package:DentaCarts/blocs/whishlist/wishlist_cubit.dart';
import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/blocs/cart/cart_cubit.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:DentaCarts/screen/instruments_screen.dart';
import 'package:DentaCarts/services/cart_api_service.dart';
import 'package:DentaCarts/services/product_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Wishlist', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WishlistError) {
            return Center(child: Text(state.message));
          } else if (state is WishlistLoaded) {
            final items =
                state.wishlist.map((json) => Product.fromJson(json)).toList();
            if (items.isEmpty) {
              return const EmptyWishlist();
            } else {
              return FilledWishlist(wishlistItems: items);
            }
          }
          return const SizedBox();
        },
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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const InstrumentsScreen()),
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

class FilledWishlist extends StatelessWidget {
  final List<Product> wishlistItems;

  const FilledWishlist({super.key, required this.wishlistItems});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final product = wishlistItems[index];
                return WishlistItem(product: product);
              },
            ),
          ),
        ],
      ),
    );
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

class WishlistItem extends StatefulWidget {
  final Product product;

  const WishlistItem({super.key, required this.product});

  @override
  _WishlistItemState createState() => _WishlistItemState();
}

class _WishlistItemState extends State<WishlistItem> {
  @override
  void initState() {
    super.initState();
  }

  void addToCart() async {
    try {
      debugPrint("Adding to cart: ${widget.product.id}");
      print(
          "Trying to add product to cart: id=${widget.product.id}, title=${widget.product.title}");

      final response = await CartApiService().addToCart(widget.product.id, 1);

      debugPrint("Response from addToCart: $response");
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

      if (mounted) {
        context.read<CartCubit>().addItem(item);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Item added to cart successfully!"),
            backgroundColor: Color.fromARGB(255, 30, 68, 31),
          ),
        );
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains("Out of stock")) {
        errorMessage = "${widget.product.title} is out of stock";
      } else {
        debugPrint("Error: $errorMessage");
        errorMessage = "Failed to add item to cart";
      }

      debugPrint("Error: $errorMessage");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    }
  }

  void toggleWishlist() {
    context.read<WishlistCubit>().toggleWishlist(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        Text(
                          widget.product.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Stock: ${widget.product.stock}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${widget.product.price}",
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
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: () {
                    addToCart();
                  },
                  child: const Icon(
                    Icons.shopping_cart_outlined,
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
              icon: BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, state) {
                  if (state is WishlistLoaded) {
                    final isFavorite =
                        state.wishlist.contains(widget.product.id);
                    return Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              iconSize: 24,
            ),
          ),
        ),
      ],
    );
  }
}
