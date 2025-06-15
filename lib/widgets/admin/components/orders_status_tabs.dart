import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:DentaCarts/core/app_colors.dart';

class OrdersStatusTabs extends StatelessWidget {
  const OrdersStatusTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatusTab('All Orders (644)', true),
        _buildStatusTab('Shipping (100)', false),
        _buildStatusTab('Completed (500)', false),
        _buildStatusTab('Cancel (0)', false),
      ],
    );
  }

  Widget _buildStatusTab(String text, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 30),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 55),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.secondaryColor.withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: isActive ? AppColors.primaryColor : Colors.grey,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
