import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/icons/my_flutter_app_icons.dart';
import 'package:DentaCarts/screen/order_history_screen.dart';
import 'package:DentaCarts/screen/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -250,
          right: -250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE9E8).withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 650,
                height: 650,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFDE9E8).withOpacity(0.8),
                    width: 4,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 130,
                  width: 130,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondaryColor,
                        ],
                        center: Alignment.topCenter,
                        radius: 1.5,
                      )),
                ),
                const SizedBox(height: 40),
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    AppStrings.placholderImage,
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  right: 10,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.edit, color: Colors.black, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Nada Ahmed",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "nada@gmail.com",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40),
            ProfileOptionCard(
              icon: Icons.shopping_cart,
              title: "Order History",
              subtitle: "View your previous orders",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => OrderHistoryScreen()),
                );
              },
            ),
            ProfileOptionCard(
              icon: Icons.favorite,
              title: "Wishlist",
              subtitle: "View your favourite products",
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => WishlistScreen()),
                      (route) => false,
                );
              },
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.green,
                  child: const Icon(MyFlutterApp.noun_whatsapp_6843546,
                      color: Colors.white, size: 70),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: Text(
                "Log Out",
                style: GoogleFonts.poppins(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ],
    );
  }
}

class ProfileOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProfileOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppColors.secondaryColor,
          elevation: 1,
          child: ListTile(
            contentPadding: const EdgeInsets.all(20),
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              child: Icon(icon, color: Colors.white),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            trailing:
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
