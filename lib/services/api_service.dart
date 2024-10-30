import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/userModel.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000';

Future<User?> getUserProfile(String token) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/User/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      debugPrint('API Response: ${response.body}');
      final Map<String, dynamic> responseData = json.decode(response.body);
      debugPrint('Response Data: $responseData');
      if (responseData['Users'] != null) {
        return User.fromJson(responseData['Users']);
      }
    }
    return null;
  } catch (e) {
    debugPrint('API Error: $e');
    throw Exception('Failed to load profile: $e');
  }
}

  Future<bool> updateUserProfile(String token, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(userData),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
