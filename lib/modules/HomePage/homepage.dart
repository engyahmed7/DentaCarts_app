import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/HomePage/widgets/carousel_slider.dart';
import 'package:flutter_application_1/modules/HomePage/widgets/category_list.dart';
import 'package:flutter_application_1/modules/HomePage/widgets/product_list.dart';
import 'widgets/section_header.dart';
import 'widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'DentaCarts',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Groups'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.teal,
        onTap: (index) {},
      ),
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
          ],
        ),
      ),
    );
  }
}
