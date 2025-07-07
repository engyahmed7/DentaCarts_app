class ProductModel {
  final int id;
  final String title;
  final String description;
  ProductModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }

  // Factory for list
  static List<ProductModel> listFromJson(List<dynamic> data) =>
      data.map((item) => ProductModel.fromJson(item)).toList();
}
