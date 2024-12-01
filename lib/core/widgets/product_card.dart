import 'dart:convert';
import 'package:DentaCarts/constants/app_exports.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../controller/Auth/auth_cubit.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String price;
  final String imageUrl;
  final String prodId;
  final bool cartDesign;
  final int qty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const ProductCard({
    required this.onIncrement,
    required this.onDecrement,
    required this.qty,
    required this.onRemove,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.prodId,
    super.key,
    required this.cartDesign,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.cartDesign) {
      return buildCartDesignIsAdded();
    } else {
      return buildHomePageCartDesign();
    }
  }

  Widget buildCartDesignIsAdded() => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(14),
                ),
                width: 150,
                height: 125,
                child: Image.network(
                  widget.imageUrl,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: widget.onRemove,
                          icon: const Icon(Icons.remove_circle),
                        ),
                      ],
                    ),
                    Text(
                      '\$${widget.price}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.teal,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: widget.onDecrement,
                          icon: const Icon(Icons.remove),
                        ),
                        Text(widget.qty.toString()),
                        IconButton(
                          onPressed: widget.onIncrement,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildHomePageCartDesign() => SizedBox(
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
                          onPressed: widget.onIncrement,
                          icon: const Icon(Icons.add_shopping_cart),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
