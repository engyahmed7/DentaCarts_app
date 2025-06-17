import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShippingApiService {
  final String apiBaseUrl = 'http://127.0.0.1:8000/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<String>> getGovernorates() async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('$apiBaseUrl/governorates'),
      headers: {
        'Authorization': 'Bearer ${token ?? ''}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    print('Fetching governorates with token: $token');
    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load governorates');
    }
  }

  Future<bool> submitShippingFee({
    required String governorate,
    required double fee,
  }) async {
    try {
      final token = await _getToken();
      print('Submitting shipping fee for $governorate with fee $fee');
      final res = await http.post(
        Uri.parse('$apiBaseUrl/shipping-fees'),
        headers: {
          'Authorization': 'Bearer ${token ?? ''}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'governorate': governorate,
          'fee': fee,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to submit shipping fee: ${res.body}');
      }
    } catch (e) {
      print('Error submitting shipping fee: $e');
      return false;
    }
  }
}
