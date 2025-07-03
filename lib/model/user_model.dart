class UserModel {
  final String image;
  final String fullName;
  final String birthDate;
  final String email;
  final String username;
  final String gender;
  final String role;

  UserModel({
    required this.image,
    required this.fullName,
    required this.birthDate,
    required this.email,
    required this.username,
    required this.gender,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      image: json['image'] ?? '',
      fullName: json['full_name'] ?? '',
      birthDate: json['birth_date'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      gender: json['gender'] ?? '',
      role: json['role'] ?? '',
    );
  }
}