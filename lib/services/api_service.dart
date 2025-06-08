import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:DentaCarts/model/userModel.dart';

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000/api/auth";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    print('Response body: ${response.body}');

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseData['token']);

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
      String email, String password, String username,
      {String? role}) async {
    final requestBody = {
      "email": email,
      "password": password,
      "username": username,
      "gender": "male",
    };

    if (role != null) {
      requestBody["role"] = role;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    print('Response body: ${response.body}');
    print('Status code: ${response.statusCode}');

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
      return null;
    }
  }

  Future<User?> updateUserProfile(
      String username, String email, File? imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return null;

    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/profile'));
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['username'] = username;
      request.fields['email'] = email;

      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        print(
            "Error updating profile: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception updating profile: $e");
      return null;
    }
  }
}
