import 'package:DentaCarts/core/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('${AppStrings.marwanHoo}'),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.edit, color: Colors.black, size: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text("Nada Ahmed", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("nada@gmail.com", style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
          SizedBox(height: 20),
          ProfileOptionCard(
            icon: Icons.shopping_cart,
            title: "Order History",
            subtitle: "View your previous orders",
          ),
          ProfileOptionCard(
            icon: Icons.favorite,
            title: "Wishlist",
            subtitle: "View your favourite products",
          ),
          Spacer(),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.green,
            child: Icon(Icons.facebook, color: Colors.white, size: 30),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {},
            child: Text("Log Out", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class ProfileOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ProfileOptionCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red.shade100,
            child: Icon(icon, color: Colors.red),
          ),
          title: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        ),
      ),
    );
  }
}

