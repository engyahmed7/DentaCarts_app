import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/CartPage/Screens/cart_screen.dart';
import 'package:flutter_application_1/modules/HomePage/home_screen.dart';
import 'package:flutter_application_1/modules/HomePage/widgets/carousel_slider.dart';
import 'package:flutter_application_1/modules/HomePage/widgets/category_list.dart';
import 'package:flutter_application_1/modules/HomePage/widgets/product_list.dart';
import 'package:flutter_application_1/modules/ProfilePage/screens/profile_screen.dart';
import '../modules/HomePage/widgets/section_header.dart';
import '../modules/HomePage/widgets/search_bar.dart';

class LayoutModules extends StatefulWidget {
  const LayoutModules({super.key});

  @override
  State<LayoutModules> createState() => _LayoutModulesState();
}

class _LayoutModulesState extends State<LayoutModules> {
  int currentIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    CartScreen(),
    ProfileScreen(),
  ];
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
            onPressed: () {

            },
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
        currentIndex: currentIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: screens[currentIndex],
    );
  }
}

