import 'package:DentaCarts/utils/admin_utils.dart';
import 'package:flutter/material.dart';
import 'package:DentaCarts/core/app_colors.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabChanged;

  const AdminSidebar({
    super.key,
    required this.selectedTabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondaryColor,
      width: 300,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        children: [
          _buildLogo(),
          const SizedBox(height: 30),
          ..._buildNavigationButtons(),
          const Spacer(),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset("assets/icon/logo.png", width: 220);
  }

  List<Widget> _buildNavigationButtons() {
    final navigationItems = [
      NavigationItem("Add Product", Icons.add_box, 0),
      NavigationItem("Manage Products", Icons.shopping_bag_sharp, 1),
      NavigationItem("Manage Orders", Icons.receipt_long, 2),
      NavigationItem("Manage Home Screen", Icons.home, 3),
    ];

    return navigationItems
        .map((item) => _buildSidebarButton(
              item.title,
              item.icon,
              isSelected: selectedTabIndex == item.index,
              onTap: () => onTabChanged(item.index),
            ))
        .toList();
  }

  Widget _buildLogoutButton(BuildContext context) {
    return _buildSidebarButton(
      "Log out",
      Icons.logout,
      isLogout: true,
      onTap: () => _handleLogout(context),
    );
  }

  Widget _buildSidebarButton(
    String title,
    IconData icon, {
    bool isSelected = false,
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondaryColor.withOpacity(0.7)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected ? AppColors.primaryColor : Colors.black54,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.primaryColor : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await AdminUtils.showConfirmDialog(
      context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      confirmText: 'Logout',
    );

    if (shouldLogout) {
      await AdminUtils.logout(context);
    }
  }
}

class NavigationItem {
  final String title;
  final IconData icon;
  final int index;

  NavigationItem(this.title, this.icon, this.index);
}
