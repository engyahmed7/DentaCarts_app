import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:DentaCarts/admin/html_stub.dart'
    if (dart.library.html) 'dart:html' as html;

class ProductApiService {
  final String baseUrl = "https://server.dentallink.co/api/";

  Future<List<dynamic>> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}products/'),
        headers: {"Authorization": "Bearer $token"},
      );

      print("Response Body product api : ${response.body}");
      print("Response product api : $response");
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

  Future<List<Map<String, dynamic>>> fetchAllCategoriesWithIdAndName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}categories'),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map<Map<String, dynamic>>((cat) => {
                  'id': cat['id'].toString(),
                  'name': cat['name'].toString(),
                })
            .toList();
      } else {
        throw Exception("Failed to load all categories");
      }
    } catch (e) {
      throw Exception("Error fetching all categories: $e");
    }
  }

  Future<bool> toggleWishlist(String productId) async {
    print("Toggling wishlist for product: $productId");
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
        print("Response Body: ${response.body}");
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

    if (token == null) {
      print("Token not found in SharedPreferences.");
      return false;
    }

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

        bool isWishlisted =
            wishlist.any((item) => item["productId"] == productId);
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

  Future<List<dynamic>> fetchProductsByCategory(String category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}products/category/$category'),
        headers: {"Authorization": "Bearer $token"},
      );
      print("Response Body: ${response.body}");
      print("Response : $response");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['products']);
        return data['products'];
        // return data['products'];
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }

  Future<List<dynamic>> fetchCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}products/categories'),
        headers: {"Authorization": "Bearer $token"},
      );
      print("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      throw Exception("Error fetching categories: $e");
    }
  }

  Future<List<dynamic>> searchProducts(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('${baseUrl}products/search?query=$query'),
      headers: {"Authorization": "Bearer $token"},
    );

    print("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Failed to search products");
    }
  }

  Future<void> submitRating({
    required String productId,
    required int rating,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('${baseUrl}products/rating/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'productId': productId,
        'rating': rating,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Rating submitted: ${data['product']}");
    } else {
      print("Error submitting rating: ${response.body}");
    }
  }

  Future<double> fetchAverageRating(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
        '${baseUrl}products/rating/$productId',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['rating'] as num).toDouble();
    } else {
      print("Error fetching rating: ${response.body}");
      throw Exception('Failed to load rating');
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
    print('Token: $token');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}products/'),
      );

      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();
      request.fields['category_id'] = category;
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
          if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
            return 'image/jpeg';
          }
          if (fileName.endsWith('.webp')) return 'image/webp';
          return 'application/octet-stream';
        }

        var multipartFile = http.MultipartFile.fromBytes(
          'images',
          imageBytes,
          filename: image.name,
          contentType: MediaType.parse(getContentType(image.name)),
        );
        request.files.add(multipartFile);
      }

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

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

        if (errorData['errors'] != null && errorData['errors'] is List) {
          List<dynamic> errors = errorData['errors'];
          String errorMessage = errors.map((error) => error['msg']).join('\n');
          throw Exception(errorMessage);
        } else {
          String errorMessage =
              errorData['message'] ?? 'An unexpected error occurred';
          throw Exception(errorMessage);
        }
      }
    } catch (e) {
      print('Error adding product: $e');
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  Future<Map<String, dynamic>> editProduct({
    required String productId,
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
        'PUT',
        Uri.parse('${baseUrl}products/$productId'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();
      request.fields['category'] = category;
      request.fields['stock'] = stock.toString();

      print('Request Fields: ${request.fields}');

      for (var image in images) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(image);
        await reader.onLoadEnd.first;
        final imageBytes = reader.result as List<int>;
        print('File size: ${imageBytes.length} bytes');
        print('File name: ${image.name}');

        String getContentType(String fileName) {
          if (fileName.endsWith('.png')) return 'image/png';
          if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
            return 'image/jpeg';
          }
          if (fileName.endsWith('.webp')) return 'image/webp';
          return 'application/octet-stream';
        }

        var multipartFile = http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: image.name,
          contentType: MediaType.parse(getContentType("$image.name")),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        return jsonResponse;
      } else {
        print('Error editing product: ${response.reasonPhrase}');
        final errorResponse = await response.stream.bytesToString();
        final errorData = jsonDecode(errorResponse);
        print('Error Data: $errorData');
        throw Exception('Failed to edit product');
      }
    } catch (e) {
      print('Error editing product: $e');
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  Future<void> deleteProduct(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}products/$productId'),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        print('Product deleted successfully');
      } else {
        print('Error deleting product: ${response.reasonPhrase}');
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      print('Error deleting product: $e');
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }
}
