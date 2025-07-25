import 'dart:convert';
import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CategorySection extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryModel>?>(
      future: getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading banner'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No banner available'));
        } else {
          List<CategoryModel> categories = snapshot.data!;
          return SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                CategoryModel category = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF8B0000),
                        radius: 25,
                        child: Icon(
                          categoriesMap[index]['icon'],
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(category.name,
                          style: GoogleFonts.poppins(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }


}
final List<Map<String, dynamic>> categoriesMap = [
  {
    'icon': Icons.local_hospital,
    'label': 'Perio & Surgery',
  },
  {
    'icon': Icons.build,
    'label': 'Instruments',
  },
  {
    'icon': Icons.medical_services,
    'label': 'Consumables',
  },
  {
    'icon': Icons.healing,
    'label': 'Implant',
  },
  {
    'icon': Icons.local_hospital,
    'label': 'Perio & Surgery',
  },
  {
    'icon': Icons.build,
    'label': 'Instruments',
  },
  {
    'icon': Icons.medical_services,
    'label': 'Consumables',
  },
  {
    'icon': Icons.healing,
    'label': 'Implant',
  },
  {
    'icon': Icons.local_hospital,
    'label': 'Perio & Surgery',
  },
];


Future<List<CategoryModel>?> getCategories() async {
  final response = await http.get(
    Uri.parse('${AppStrings.baseUrl}/api/categories'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return CategoryModel.listFromJson(data);
  } else {
    return null;
  }
}
