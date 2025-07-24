class CartModel {
  final int id;
  final String cartId;
  final String productId;
  final String name;
  final String price;
  final String quantity;
  final String stock;

  CartModel({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.stock,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      cartId: json['cart_id'],
      productId: json['productId'],
      name: json['name'],
      price: json['price'],
      quantity: json['qty'],
      stock: json['stock'],
    );
  }

  // Factory for list
  static List<CartModel> listFromJson(List<dynamic> data) =>
      data.map((item) => CartModel.fromJson(item)).toList();
}
