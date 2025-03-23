import 'dart:convert';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final int stock;
  final double rating;
  final int reviews;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.stock,
    required this.rating,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? 'Unknown Product',
      description: json['description'] ?? 'No description available',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? 'Uncategorized',
      images:
          (json['img'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
              (json['image'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
      stock: json['stock'] ?? 0,
      rating: (json['totalRating']?['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: (json['totalRating']?['user'] as List?)?.length ?? 0,
    );
  }
}

List<Product> parseProducts(String responseBody) {
  final parsed = json.decode(responseBody)['products'] as List;
  return parsed.map((json) => Product.fromJson(json)).toList();
}
