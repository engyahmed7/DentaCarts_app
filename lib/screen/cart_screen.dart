import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/screen/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final List<Map<String, dynamic>> cartItems = List.generate(3, (index) => {
    'name': "Dental Instruments",
    'price': 8.54,
    'image': '${AppStrings.placholderImage}',
    'rating': 5.0,
    'reviews': "70,000+",
  });

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(0, (sum, item) => sum + item['price']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Your Products", style: GoogleFonts.poppins(color: Colors.black)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "${cartItems.length} Item(s)",
                style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return CartItemCard(item: cartItems[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("TOTAL", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      "\$${totalPrice.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=> PaymentScreen()));
                    },
                    child: Text("Check out", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}



class CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.network(item['image'], height: 80, width: 80, fit: BoxFit.cover),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      SizedBox(width: 5),
                      Text(item['reviews'], style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text(item['name'], style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("\$${item['price']}", style: GoogleFonts.poppins(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.red),
                        onPressed: () {},
                      ),
                      Text("1", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.green),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
