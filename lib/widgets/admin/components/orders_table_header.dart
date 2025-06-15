import 'package:flutter/material.dart';
import 'package:DentaCarts/core/app_colors.dart';

class OrdersTableHeader extends StatelessWidget {
  const OrdersTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSearchField(),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 45,
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for id,name,product',
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          suffixIcon: const Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        _buildActionButton('Filter', Icons.filter_list, () {}),
        const SizedBox(width: 15),
        _buildActionButton('Export', Icons.file_download, () {}),
        const SizedBox(width: 15),
        _buildActionButton('New Product', Icons.add, () {}, isPrimary: true),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed,
      {bool isPrimary = false}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: isPrimary ? Colors.white : Colors.black),
      label: Text(label,
          style: TextStyle(color: isPrimary ? Colors.white : Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primaryColor : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
