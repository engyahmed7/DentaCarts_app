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
  int currentIndex = 0;

  List<Widget> screen =  [
    HomeScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      //drawer: const Drawer(),
      body: screen[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
            if(index == 1) getCarts();
          });
        },
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primaryColor,
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
      //  floatingActionButton: currentIndex == 1
      //  ? FloatingActionButton(
      //   onPressed: () {
      //
      //   },
      //   backgroundColor: AppColors.primaryColor,
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // )
      //      : null,
    );
  }
}
