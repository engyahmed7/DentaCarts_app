import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TablePagination extends StatelessWidget {
  const TablePagination({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('1 of 5 pages', style: GoogleFonts.poppins()),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
