import 'dart:convert';

import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/view/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FawaterakScreen extends StatefulWidget {
  final Map dataUser;
  const FawaterakScreen({super.key, required this.dataUser});

  @override
  State<FawaterakScreen> createState() => _FawaterakScreenState();
}

class _FawaterakScreenState extends State<FawaterakScreen> {


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }



  Future<void> orders(context) async {
    final response = await http.post(
      Uri.parse('${AppStrings.baseUrl}/api/orders/pay'),
      body: jsonEncode({
          "payment_method_id": "card",
          "first_name":widget.dataUser['first_name'],
          "last_name":widget.dataUser['last_name'],
          "address_line": widget.dataUser['address_line'],
          "country": widget.dataUser['country'],
          "city": widget.dataUser['city'],
          "state": widget.dataUser['state'],
          "postal_code": widget.dataUser['postal_code'],
          "phone": widget.dataUser['phone'],
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${data}")));
    }
  }


}