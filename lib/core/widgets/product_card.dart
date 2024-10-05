import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String price;
  final String imageUrl;
  final bool cartDesign;

  const ProductCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    super.key,
    required this.cartDesign,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isAddedToCart = false;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    if (widget.cartDesign) {
      return buildCartDesignIsAdded();
    } else {
      return buildHomePageCartDesign(context);
    }
  }

  Widget buildCartDesignIsAdded() => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${widget.price}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.teal,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isAddedToCart = !isAddedToCart;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBarAnimationStyle: AnimationStyle(
                                duration: const Duration(seconds: 1)),
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(milliseconds: 500),
                              content: Text(isAddedToCart
                                  ? "Done Add To Cart"
                                  : "Removed To Cart"),
                            ),
                          );
                        },
                        icon: Icon(isAddedToCart
                            ? Icons.check_circle_rounded
                            : Icons.add_shopping_cart),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      snackBarAnimationStyle:
                          AnimationStyle(duration: const Duration(seconds: 1)),
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(milliseconds: 500),
                        content: Text(isFavorite
                            ? "Add To Favorite"
                            : "Remove From Favorite"),
                      ),
                    );
                  },
                  icon:
                      Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                ),
              ),
            ),
          ],
        ),
      );

  SizedBox buildHomePageCartDesign(BuildContext context) => SizedBox(
        width: 160,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      widget.imageUrl,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.price}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.teal,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isAddedToCart = !isAddedToCart;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBarAnimationStyle: AnimationStyle(
                                  duration: const Duration(seconds: 1)),
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(milliseconds: 500),
                                content: Text(isAddedToCart
                                    ? "Done Add To Cart"
                                    : "Removed To Cart"),
                              ),
                            );
                          },
                          icon: Icon(isAddedToCart
                              ? Icons.check_circle_rounded
                              : Icons.add_shopping_cart),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        snackBarAnimationStyle: AnimationStyle(
                            duration: const Duration(seconds: 1)),
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(milliseconds: 500),
                          content: Text(isFavorite
                              ? "Add To Favorite"
                              : "Remove From Favorite"),
                        ),
                      );
                    },
                    icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
