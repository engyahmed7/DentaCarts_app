import 'dart:convert';

import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/view/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CashScreen extends StatelessWidget {
  final Map dataUser;
  const CashScreen({super.key, required this.dataUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Screen'),
      ),
      body: Column(
        children: [
          Text(dataUser['address_line']),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B0000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async{
                await orders(context);
              },
              child: Text(
                "Create Order",
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> orders(context) async {
    final response = await http.post(
      Uri.parse('${AppStrings.baseUrl}/api/orders'),
      body: jsonEncode({
        "address_line": dataUser['address_line'],
        "city": dataUser['city'],
        "state": dataUser['state'],
        "postal_code": dataUser['postal_code'],
        "country": dataUser['country'],
        "phone": dataUser['phone']
      }),

      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppStrings.token}',
      },
    );
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cash Created Successfully")));
      await getCarts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${data}")));
    }
  }


}



