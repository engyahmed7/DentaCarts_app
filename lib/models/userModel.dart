class User {
  final String id;
  final String username;
  final String email;
  final String image;
  final String role;
  final bool verified;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.image,
    required this.role,
    required this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? 'https://via.placeholder.com/150',
      role: json['role'] ?? 'user',
      verified: json['verified'] ?? false,
    );
  }
}
