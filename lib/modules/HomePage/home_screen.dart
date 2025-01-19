import 'package:flutter/material.dart';
import 'package:DentaCarts/modules/HomePage/widgets/carousel_slider.dart';
import 'package:DentaCarts/modules/HomePage/widgets/category_list.dart';
import 'package:DentaCarts/modules/HomePage/widgets/product_list.dart';
import 'package:DentaCarts/modules/HomePage/widgets/search_bar.dart';
import 'package:DentaCarts/modules/HomePage/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const SearchBarr(),
          const CarouselSliderWidget(),
          const CategoryList(),
          const SectionHeader(title: 'On Sale', actionLabel: 'See More'),
          const ProductList(),
          Container(
            margin: const EdgeInsets.all(24.0),
            child: Image.asset('visa.png'),
          ),
          const SectionHeader(title: 'Best Seller', actionLabel: 'See More'),
          const ProductList(),
          const SizedBox(height: 24.0),
          const SectionHeader(title: 'Shop By Vendor', actionLabel: 'See More'),
          const ProductList(),
          const SizedBox(height: 24.0),
        ],
      ),
    ));
  }
}
