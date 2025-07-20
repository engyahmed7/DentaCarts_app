class CartModel {
  final int id;
  final String name;
  final String price;
  CartModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }

  // Factory for list
  static List<CartModel> listFromJson(List<dynamic> data) =>
      data.map((item) => CartModel.fromJson(item)).toList();
}
