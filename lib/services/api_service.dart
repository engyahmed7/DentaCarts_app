import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:DentaCarts/model/userModel.dart';

class ApiService {
  final String baseUrl = "http://localhost:3000";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    print('Response body: ${response.body}');

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      
      return responseData;
    } else {
      if (responseData.containsKey("errors")) {
        List<dynamic> errors = responseData["errors"];
        if (errors.isNotEmpty) {
          return {
            "error": true,
            "message": errors[0]["msg"],
          };
        }
      }

      return {
        "error": true,
        "message": responseData["Error"] ?? "Login failed"
      };
    }
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "username": username,
        "gender": "male",
      }),
    );

    print('Response body: ${response.body}');

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseData;
    } else {
      if (responseData.containsKey("errors")) {
        List<dynamic> errors = responseData["errors"];
        if (errors.isNotEmpty) {
          return {
            "error": true,
            "message": errors[0]["msg"],
          };
        }
      }

      return {
        "error": true,
        "message": responseData["Error"] ?? "Register failed"
      };
    }
  }

  Future<User?> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return false;

    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );

    return response.statusCode == 200;
  }
}
