
import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:DentaCarts/services/cart_api_service.dart';
import 'package:DentaCarts/view/details_produc_screen.dart';
import 'package:DentaCarts/view/home/banner_section.dart';
import 'package:DentaCarts/view/home/category_section.dart';
import 'package:DentaCarts/view/home/product_list_section.dart';
import 'package:DentaCarts/view/instruments_screen.dart';
import 'package:DentaCarts/viewmodel/cart/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../admin/services/product_api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // TextField(
            //   decoration: InputDecoration(
            //     hintText: "Search ....",
            //     prefixIcon: Icon(Icons.search),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10),
            //       borderSide: BorderSide.none,
            //     ),
            //     filled: true,
            //     fillColor: Colors.grey.shade200,
            //   ),
            // ),
            const SizedBox(height: 20),
            const BannerSection(),
            const SizedBox(height: 20),
            Text("Categories",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            CategorySection(categories: categoriesMap),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("On Sale",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (_) => const InstrumentsScreen()),
                    // );
                  },
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const SaleProductsList(),
          ],
        ),
      ),
    );
  }
}





