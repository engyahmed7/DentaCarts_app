import 'package:DentaCarts/admin/view/login_screen_admin.dart';
import 'package:DentaCarts/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminUtils {
  static Future<void> logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      // await prefs.remove('user_data');

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreenAdmin()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during logout: $e'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    }
  }

  static void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showInfoMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText, style: TextStyle(color: Colors.grey[800])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText,
                style: const TextStyle(color: AppColors.primaryColor)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPrice(String price) {
    final double? parsedPrice = double.tryParse(price);
    return parsedPrice != null && parsedPrice > 0;
  }

  static bool isValidStock(String stock) {
    final int? parsedStock = int.tryParse(stock);
    return parsedStock != null && parsedStock >= 0;
  }
}
