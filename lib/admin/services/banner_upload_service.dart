import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:DentaCarts/admin/html_stub.dart'
if (dart.library.html) 'dart:html' as html;

class BannerUploadService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<String> uploadBanner(html.File file, String? token) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload/banner'),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final bytes = await _fileToBytes(file);
      request.files.add(
        http.MultipartFile.fromBytes(
          'banner',
          bytes,
          filename: file.name,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['banner_url'] ?? responseData['url'];
      } else {
        throw Exception('Failed to upload banner: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error uploading banner: $e');
    }
  }

  static Future<bool> deleteBanner(String bannerUrl, String? token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/upload/banner'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({'banner_url': bannerUrl}),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Uint8List> _fileToBytes(html.File file) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;
    return reader.result as Uint8List;
  }

  static bool isValidImageFile(html.File file) {
    final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    final fileName = file.name!.toLowerCase();
    return allowedExtensions.any((ext) => fileName.endsWith('.$ext'));
  }

  static bool isValidFileSize(html.File file, {int maxSizeInMB = 5}) {
    return file.size <= maxSizeInMB * 1024 * 1024;
  }
}
