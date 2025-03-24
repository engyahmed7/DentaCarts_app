import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductApiService {
  final String baseUrl = "http://localhost:3000/";

  Future<List<dynamic>> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}products/'),
        headers: {"Authorization": "Bearer $token"},
      );

      print("Response Body: ${response.body}");
      print("Response : $response");
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

  Future<bool> toggleWishlist(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}wishlist/toggle/'),
        body: jsonEncode({"productId": productId}),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(response.body);

        if (data.containsKey("wishList") &&
            (data["wishList"] as List).isEmpty) {
          return false;
        }

        return data["message"] == "Added to favorites";
      } else if (response.statusCode == 204) {
        print("Item removed from wishlist.");
        return false;
      } else {
        print("Error: Unexpected response code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error toggling wishlist: $e");
      return false;
    }
  }

  Future<bool> checkIfWishlisted(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('${baseUrl}wishlist/'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> wishlist = jsonDecode(response.body);

        // print("Response Body from check wishlist: $wishlist");

        bool isWishlisted =
            wishlist.any((item) => item["productId"] == productId);

        // print("Wishlist check for $productId: $isWishlisted");
        return isWishlisted;
      } else {
        print("Error fetching wishlist: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error checking wishlist: $e");
      return false;
    }
  }

  Future<List<dynamic>> fetchWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('${baseUrl}wishlist/'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Wishlist data : $data");
        return data;
      } else {
        throw Exception("Failed to load wishlist");
      }
    } catch (e) {
      print("Error fetching wishlist apii: $e");
      throw Exception("Error fetching wishlist api: $e");
    }
  }


}
