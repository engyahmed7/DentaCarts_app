class WishlistModel {
  final int id;
  final String wishlistId;
  final String productId;
  final String name;
  final String price;
  final String stock;
  WishlistModel({
    required this.id,
    required this.wishlistId,
    required this.productId,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'],
      wishlistId: json['wishlist_id'],
      productId: json['productId'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'],
    );
  }

  // Factory for list
  static List<WishlistModel> listFromJson(List<dynamic> data) =>
      data.map((item) => WishlistModel.fromJson(item)).toList();
}
