class CartModel {
  final int id;
  final String title;
  final String description;
  CartModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }

  // Factory for list
  static List<CartModel> listFromJson(List<dynamic> data) =>
      data.map((item) => CartModel.fromJson(item)).toList();
}
