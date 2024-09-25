import 'package:flutter/material.dart';
import 'category_button.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.construction, 'label': 'Consumables'},
      {'icon': Icons.build, 'label': 'Instrument'},
      {'icon': Icons.health_and_safety, 'label': 'Implant'},
      {'icon': Icons.local_hospital, 'label': 'Perio & Surgery'},
      {'icon': Icons.toc, 'label': 'Orthodontics'},
      {'icon': Icons.construction, 'label': 'Consumables'},
      {'icon': Icons.health_and_safety, 'label': 'Implant'},
      {'icon': Icons.health_and_safety, 'label': 'Implant'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: CategoryButton(
                icon: category['icon'] as IconData,
                label: category['label'] as String,
              ),
            );
          },
        ),
      ),
    );
  }
}
