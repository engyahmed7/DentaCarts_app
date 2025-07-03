class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String createdAt;
  final String updatedAt;
  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Factory for list
  static List<CategoryModel> listFromJson(List<dynamic> data) =>
      data.map((item) => CategoryModel.fromJson(item)).toList();
}
