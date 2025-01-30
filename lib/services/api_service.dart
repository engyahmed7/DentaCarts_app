import 'dart:convert';
import 'package:DentaCarts/model/userModel.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<User?> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/profile'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<bool> updateUserProfile(String token, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/profile'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );

    return response.statusCode == 200;
  }
}
