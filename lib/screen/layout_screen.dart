import 'package:DentaCarts/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutScreen extends StatefulWidget {
  final int? currentIndex;

  const LayoutScreen({super.key, this.currentIndex});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
   int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    //Logger().i(BlocProvider.of<AuthCubit>(context).token);
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          // NotificationScreen(),
          // const OrderScreen(),
          // const HomeScreen(),
          // const MyFamilyScreen(),
          // const MoreScreen(),
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
        items: [
          BottomNavigationBarItem(
            icon: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.home,
              ),
            ),
            label:  "Home",
          ),
          BottomNavigationBarItem(
            icon: const Padding(
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
            label:  "Profile",
          ),
        ],
      ),
    );
  }
}
