import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductApiService {
  final String baseUrl = "http://localhost:3000/products/";

  Future<List<dynamic>> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      print("Response Body: ${response.body}");
      print("Response : ${response}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print(data['products']);
        return data['products'];
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }
}
