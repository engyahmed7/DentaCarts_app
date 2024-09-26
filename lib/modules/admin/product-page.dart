import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;

void main() {
  runApp(const ProductAdminPanel());
}

class ProductAdminPanel extends StatelessWidget {
  const ProductAdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.tealAccent, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Product Admin Panel'),
          centerTitle: true,
          elevation: 0,
        ),
        body: const ProductForm(),
      ),
    );
  }
}

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  String? imageUrl;

  void _pickImage() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final file = input.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen((event) {
          setState(() {
            imageUrl = reader.result as String;
          });
        });
      }
    });
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      final productData = {
        'title': _titleController.text,
        'description': _descController.text,
        'price': _priceController.text,
        'image': imageUrl,
      };

      final response = await http.post(
        Uri.parse('http://localhost:4000/products/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully!'),
            backgroundColor: Colors.teal,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add product. Error: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add a New Product',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Product Title',
                filled: true,
                prefixIcon: Icon(Icons.title, color: Colors.teal),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the product title';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Product Description',
                filled: true,
                prefixIcon: Icon(Icons.description, color: Colors.teal),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the product description';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                filled: true,
                prefixIcon: Icon(Icons.attach_money, color: Colors.teal),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            if (imageUrl != null)
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Pick Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitProduct,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Submit Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
