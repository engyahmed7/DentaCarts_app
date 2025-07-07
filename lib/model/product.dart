import 'dart:convert';

class Product {
  String id;
  String title;
  String description;
  double price;
  String category;
  List<String> images;
  int stock;
  double rating;
  int reviews;

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
      id: json['_id']?.toString() ?? json['productId']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? 'Unknown Product',
      description: json['description'] ?? 'No description available',
      price: _parsePrice(json['price']),
      category: json['category'] ?? 'Uncategorized',
      images:
      (json['img'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          (json['image'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      stock: _parseInt(json['stock']),
      rating: _parseDouble(json['totalRating']?['rating']),
      reviews: (json['totalRating']?['user'] as List?)?.length ?? 0,
    );
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'img': images,
      'stock': stock,
      'totalRating': {
        'rating': rating,
        'user': List.generate(reviews, (index) => {}),
      },
    };
  }

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? category,
    List<String>? images,
    int? stock,
    double? rating,
    int? reviews,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      images: images ?? this.images,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, price: $price, category: $category, stock: $stock}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

List<Product> parseProducts(String responseBody) {
  try {
    final parsed = json.decode(responseBody);

    List<dynamic> productsList;
    if (parsed is List) {
      productsList = parsed;
    } else if (parsed is Map && parsed.containsKey('products')) {
      productsList = parsed['products'] as List;
    } else if (parsed is Map && parsed.containsKey('data')) {
      productsList = parsed['data'] as List;
    } else {
      throw Exception('Invalid response structure');
    }

    return productsList.map((json) => Product.fromJson(json)).toList();
  } catch (e) {
    print('Error parsing products: $e');
    return [];
  }
}
