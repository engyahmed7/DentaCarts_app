import 'package:DentaCarts/core/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, String>> categories = [
    {'icon': '🦷', 'label': 'perio & Surgery'},
    {'icon': '🔧', 'label': 'Instruments'},
    {'icon': '💊', 'label': 'Consumables'},
    {'icon': '🦴', 'label': 'Implant'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Search ....",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
            SizedBox(height: 20),
            BannerSection(),
            SizedBox(height: 20),
            Text("Categories",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            CategorySection(categories: categories),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("On Sale",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text("View All",
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10),
            SaleProductCard(),
          ],
        ),
      ),
    );
  }
}

class BannerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Dental Link Offers",
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("Get 20% OFF on MH Group Products."),
              ],
            ),
          ),
          Image.network(
            '${AppStrings.marwanHoo}',
            height: 80,
          ),
        ],
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final List<Map<String, String>> categories;

  const CategorySection({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((category) {
        return Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red.shade100,
              radius: 25,
              child: Text(category['icon']!, style: TextStyle(fontSize: 24)),
            ),
            SizedBox(height: 5),
            Text(category['label']!, style: GoogleFonts.poppins(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}

class SaleProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.network('${AppStrings.marwanHoo}', height: 80),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      SizedBox(width: 5),
                      Text("70,000+",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text("Dental Instruments",
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  Text("USP Grade Vitamin C, 1000 mg, 60 Veggie Capsules",
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey)),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(r"$12.20",
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey)),
                      SizedBox(width: 10),
                      Text("\$8.54",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      SizedBox(width: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text("30% OFF",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
