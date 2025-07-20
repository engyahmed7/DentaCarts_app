class WishlistModel {
  final int id;
  final String name;
  final String price;
  WishlistModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }

  // Factory for list
  static List<WishlistModel> listFromJson(List<dynamic> data) =>
      data.map((item) => WishlistModel.fromJson(item)).toList();
}
