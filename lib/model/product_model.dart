class ProductModel {
  final int id;
  final String categoryId;
  final String title;
  final String description;
  final String price;
  final String stock;
  ProductModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,


  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
    );
  }

  // Factory for list
  static List<ProductModel> listFromJson(List<dynamic> data) =>
      data.map((item) => ProductModel.fromJson(item)).toList();
}
