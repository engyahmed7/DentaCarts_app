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
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      images: List<String>.from(json['image']),
      stock: json['stock'],
      rating: (json['totalRating']['rating'] as num).toDouble(),
      reviews: (json['totalRating']['user'] as List).length,
      
    );
  }
}

List<Product> parseProducts(String responseBody) {
  final parsed = json.decode(responseBody)['products'] as List;
  return parsed.map((json) => Product.fromJson(json)).toList();
}
