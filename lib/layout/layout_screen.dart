import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/view/cart/cart_screen.dart';
import 'package:DentaCarts/view/home/home_screen.dart';
import 'package:DentaCarts/view/profile_screen.dart';
import 'package:flutter/material.dart';

class LayoutScreen extends StatefulWidget {
  final int? currentIndex;

  const LayoutScreen({super.key, this.currentIndex});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: IndexedStack(
          index: currentIndex,
          children: const [
            Text("Home"),
            Text("Cart"),
            Text("Profile"),

          ],
        ),
      ),
      drawer: const Drawer(),
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(),
          const CartScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        iconSize: 35,
        elevation: 50,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.home,
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.shopping_cart,
              ),
            ),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.person,
              ),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
