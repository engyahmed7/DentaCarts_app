import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';

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

// admin apis
  Future<Map<String, dynamic>> addProduct({
    required String title,
    required String description,
    required double price,
    required String category,
    required List<html.File> images,
    required int stock,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:3000/products/'),
      );

      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();
      request.fields['category'] = category;
      request.fields['stock'] = stock.toString();

      for (var image in images) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(image);
        await reader.onLoadEnd.first;
        final imageBytes = reader.result as List<int>;
        print('File size: ${imageBytes.length} bytes');
        print('File name: ${image.name}');

        String getContentType(String fileName) {
          if (fileName.endsWith('.png')) return 'image/png';
          if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg'))
            return 'image/jpeg';
          if (fileName.endsWith('.webp')) return 'image/webp';
          return 'application/octet-stream';
        }

        var multipartFile = http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: image.name,
          contentType: MediaType.parse(getContentType(image.name)),
        );
        request.files.add(multipartFile);
      }

      request.headers['Authorization'] = 'Bearer $token';
      print('Request Fields: ${request.fields}');

      var response = await request.send();
      print('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        print('Product Added: $data');
        return data;
      } else {
        final errorResponse = await response.stream.bytesToString();
        final errorData = jsonDecode(errorResponse);
        throw Exception(errorData['message'] ?? 'Failed to add product');
      }
    } catch (e) {
      print('Error adding product: $e');
      throw Exception('Error adding product: $e');
    }
  }



}
