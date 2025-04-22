import 'dart:html' as html;
import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:DentaCarts/services/api_service.dart';
import 'package:DentaCarts/services/product_api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _selectedImage;
  int _selectedTabIndex = 0;
  String? token;
  String username = '';
  bool _isLoading = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  List<html.File> imageFiles = [];
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      List<html.File> htmlFiles = [];

      for (var pickedFile in pickedFiles) {
        final bytes = await pickedFile.readAsBytes();
        final htmlFile = html.File([bytes], pickedFile.name);
        htmlFiles.add(htmlFile);
      }

      setState(() {
        imageFiles = htmlFiles;
      });
    } else {
      print('No images selected.');
    }
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        username = decodedToken['username'] ?? 'User';
      });
    }
  }

  Future<void> _submitProduct() async {
    String title = titleController.text;
    String description = descriptionController.text;
    double price = double.tryParse(priceController.text) ?? 0.0;
    String category = categoryController.text;
    int stock = int.tryParse(stockController.text) ?? 0;

    if (title.isNotEmpty &&
        description.isNotEmpty &&
        price > 0 &&
        category.isNotEmpty &&
        stock > 0 &&
        imageFiles.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        Map<String, dynamic> result = await ProductApiService().addProduct(
          title: title,
          description: description,
          price: price,
          category: category,
          images: imageFiles,
          stock: stock,
        );

        print('Product added successfully: $result');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        _clearInputs();
      } catch (e) {
        print('Error adding product: $e');

        String errorMessage = e.toString().replaceAll('Exception:', '').trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please fill all fields and upload at least one image.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearInputs() {
    setState(() {
      titleController.clear();
      descriptionController.clear();
      priceController.clear();
      categoryController.clear();
      stockController.clear();
      imageFiles.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(80.0),
              child: _selectedTabIndex == 0
                  ? _buildAddProductForm()
                  : _buildManageProductsTable(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      color: AppColors.secondaryColor,
      width: 300,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        children: [
          Image.asset("assets/icon/logo.png", width: 220),
          const SizedBox(height: 30),
          _buildSidebarButton("Add Product", Icons.add_box,
              isSelected: _selectedTabIndex == 0, onTap: () {
            setState(() {
              _selectedTabIndex = 0;
            });
          }),
          _buildSidebarButton("Manage Products", Icons.inventory_2_outlined,
              isSelected: _selectedTabIndex == 1, onTap: () {
            setState(() {
              _selectedTabIndex = 1;
            });
          }),
          _buildSidebarButton("Manage Orders", Icons.open_in_browser_rounded,
              isSelected: _selectedTabIndex == 2, onTap: () {
            setState(() {
              _selectedTabIndex = 2;
            });
          }),
          const Spacer(),
          _buildSidebarButton("Log out", Icons.logout, isLogout: true),
        ],
      ),
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

  Widget _buildAddProductForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Welcome Back, ",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
            children: [
              TextSpan(
                text: "\n$username!",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "Add New Product",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 20),
        _buildTextField("Product Title", Icons.title, titleController),
        _buildTextField(
            "Product Description", Icons.description, descriptionController),
        _buildTextField("Price", Icons.attach_money, priceController),
        _buildTextField("Category", Icons.category, categoryController),
        _buildTextField("Stock Quantity", Icons.numbers, stockController),
        _buildImageUploader(),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitProduct,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    "Submit Product",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primaryColor),
          filled: true,
          fillColor: AppColors.secondaryColor.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(5),
            color: AppColors.secondaryColor.withOpacity(0.8),
          ),
          child: imageFiles.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageFiles.length,
                  itemBuilder: (context, index) {
                    final imageFile = imageFiles[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.network(
                        html.Url.createObjectUrl(imageFile),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    );
                  },
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      color: AppColors.primaryColor,
                      size: 40,
                    ),
                    SizedBox(height: 5),
                    Text("Tap to upload or drag and drop files"),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildManageProductsTable() {
    return FutureBuilder<List<Product>>(
      future: ProductApiService().fetchProducts().then((products) {
        return products.map((product) => Product.fromJson(product)).toList();
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products available.'));
        }

        List<Product> products = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 45,
                    width: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for id,name,product',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon:
                            const Icon(Icons.filter_list, color: Colors.black),
                        label: const Text('Filter',
                            style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton.icon(
                        onPressed: () {
                          ProductApiService()
                              .fetchProducts()
                              .then((fetchedProducts) {
                            final products = fetchedProducts
                                .map((product) => Product.fromJson(product))
                                .toList();
                            generateAndDownloadPdf(products
                                .map((product) => {
                                      'id': product.id,
                                      'name': product.title,
                                      'price': product.price,
                                    })
                                .toList());
                          }).catchError((error) {
                            print('Error fetching products: $error');
                          });
                        },
                        icon: const Icon(Icons.file_download,
                            color: Colors.black),
                        label: const Text(
                          'Export',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('New Product',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Row(
              //   children: [
              //     _buildStatusTab('All Products (${products.length})', true),
              //     _buildStatusTab('Shipping (100)', false),
              //     _buildStatusTab('Completed (500)', false),
              //     _buildStatusTab('Cancel (0)', false),
              //   ],
              // ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                      left: BorderSide(color: Colors.grey.shade300),
                      right: BorderSide(color: Colors.grey.shade300),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.grey.shade200,
                      ),
                      child: DataTable(
                        columnSpacing: 20,
                        horizontalMargin: 20,
                        headingRowHeight: 50,
                        dataRowHeight: 60,
                        showCheckboxColumn: true,
                        dividerThickness: 1,
                        headingTextStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        dataTextStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        headingRowColor:
                            WidgetStateProperty.all(AppColors.secondaryColor),
                        columns: const [
                          DataColumn(label: Text('Product Name')),
                          DataColumn(label: Text('Stock')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: products.map((product) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    Image.network(
                                      product.images.isNotEmpty
                                          ? product.images[0]
                                          : 'assets/images/medical.png',
                                      width: 50,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          product.title,
                                          style: GoogleFonts.poppins(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(product.description),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(Text(product.stock.toString())),
                              DataCell(Text('\$${product.price}')),
                              DataCell(Text(product.category)),
                              DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 20),
                                    onPressed: () {},
                                    color: Colors.grey,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        size: 20),
                                    onPressed: () {},
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('1 of 5 pages', style: GoogleFonts.poppins()),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> generateAndDownloadPdf(
      List<Map<String, dynamic>> products) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Product Data', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('ID',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Name',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Price',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...products.map(
                    (product) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(product['id'].toString()),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(product['name']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('\$${product['price']}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();

    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'product_data.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Widget _buildManageOrdersTable() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 45,
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for id,name,product',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list, color: Colors.black),
                    label: const Text('Filter',
                        style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton.icon(
                    onPressed: () {
                      ProductApiService()
                          .fetchProducts()
                          .then((fetchedProducts) {
                        final products = fetchedProducts
                            .map((product) => Product.fromJson(product))
                            .toList();
                        generateAndDownloadPdf(products
                            .map((product) => {
                                  'id': product.id,
                                  'name': product.title,
                                  'price': product.price,
                                })
                            .toList());
                      }).catchError((error) {
                        print('Error fetching products: $error');
                      });
                    },
                    icon: const Icon(Icons.file_download, color: Colors.black),
                    label: const Text(
                      'Export',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('New Product',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatusTab('All Orders (644)', true),
              _buildStatusTab('Shipping (100)', false),
              _buildStatusTab('Completed (500)', false),
              _buildStatusTab('Cancel (0)', false),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                  left: BorderSide(color: Colors.grey.shade300),
                  right: BorderSide(color: Colors.grey.shade300),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.grey.shade200,
                  ),
                  child: DataTable(
                    columnSpacing: 20,
                    horizontalMargin: 20,
                    headingRowHeight: 50,
                    dataRowHeight: 60,
                    showCheckboxColumn: true,
                    dividerThickness: 1,
                    headingTextStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    dataTextStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    headingRowColor:
                        WidgetStateProperty.all(AppColors.secondaryColor),
                    columns: const [
                      DataColumn(label: Text('Orders')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Payment')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: List.generate(12, (index) {
                      // Remark:::: [random] --> don't forget to replace it with api data
                      final isPaid = (index % 3 == 0);
                      final isCanceled = (index % 4 == 0);
                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/medical.png',
                                  width: 50,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '02123${index + 1}',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text('Dental Insturment  name'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const DataCell(Text('Ahmed Mohamed')),
                          const DataCell(Text('\$12.78')),
                          const DataCell(Text('24/07/23')),
                          DataCell(_buildStatusChip(
                            isPaid ? 'Paid' : 'Unpaid',
                            isPaid
                                ? Colors.green.shade50
                                : Colors.orange.shade50,
                            isPaid ? Colors.green : Colors.orange,
                          )),
                          DataCell(_buildStatusChip(
                            isCanceled ? 'Canceled' : 'Shipped',
                            isCanceled
                                ? Colors.red.shade50
                                : Colors.purple.shade50,
                            isCanceled ? Colors.red : Colors.purple,
                          )),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                onPressed: () {},
                                color: Colors.grey,
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete_outline, size: 20),
                                onPressed: () {},
                                color: AppColors.primaryColor,
                              ),
                            ],
                          )),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('1 of 5 pages', style: GoogleFonts.poppins()),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTab(String text, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 30),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 55),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.secondaryColor.withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: isActive ? AppColors.primaryColor : Colors.grey,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStatusChip(
      String label, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
