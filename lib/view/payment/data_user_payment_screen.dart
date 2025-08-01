import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/view/login_screen.dart';
import 'package:DentaCarts/view/payment/cash_screen.dart';
import 'package:DentaCarts/view/payment/fawaterak_screen.dart';
import 'package:DentaCarts/view/payment/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataUserPaymentScreen extends StatefulWidget {
  final String selectedMethod;

  const DataUserPaymentScreen({super.key, required this.selectedMethod});

  @override
  State<DataUserPaymentScreen> createState() => _DataUserPaymentScreenState();
}

class _DataUserPaymentScreenState extends State<DataUserPaymentScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    postalCodeController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data User Payment ${widget.selectedMethod}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.selectedMethod == AppStrings.fawaterk)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: countryController,
              decoration: const InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: stateController,
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: postalCodeController,
              decoration: const InputDecoration(
                labelText: 'Postal Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
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
                onPressed: () {
                if (widget.selectedMethod == AppStrings.fawaterk) {
                  if (firstNameController.text.isEmpty ||
                      lastNameController.text.isEmpty ||
                      addressController.text.isEmpty ||
                      cityController.text.isEmpty ||
                      stateController.text.isEmpty ||
                      countryController.text.isEmpty ||
                      postalCodeController.text.isEmpty ||
                      phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all fields"),
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) =>  FawaterakScreen(
                      dataUser: {
                        "first_name": firstNameController.text.toString(),
                        "last_name": lastNameController.text.toString(),
                        "address_line": addressController.text.toString(),
                        "country": countryController.text.toString(),
                        "city": cityController.text.toString(),
                        "state": stateController.text.toString(),
                        "postal_code": postalCodeController.text.toString(),
                        "phone": phoneController.text.toString(),
                      },
                    )),
                  );
                }

                else if (widget.selectedMethod == AppStrings.cash) {
                  if (addressController.text.isEmpty ||
                      cityController.text.isEmpty ||
                      stateController.text.isEmpty ||
                      countryController.text.isEmpty ||
                      postalCodeController.text.isEmpty ||
                      phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all required fields"),
                      ),
                    );
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) =>  CashScreen(
                      dataUser: {
                        "address_line": addressController.text.toString(),
                        "city": cityController.text.toString(),
                        "state": stateController.text.toString(),
                        "postal_code": postalCodeController.text.toString(),
                        "country": countryController.text.toString(),
                        "phone": phoneController.text.toString(),
                      }
                    )),
                  );
                }
              },
                child: Text(
                  "Continue",
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
