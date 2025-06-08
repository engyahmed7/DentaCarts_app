import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:convert';
import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/model/homeModel.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:DentaCarts/services/product_api_service.dart';
import 'package:http/http.dart' as http;

class AdminContentSections extends StatelessWidget {
  final int selectedTabIndex;
  final String username;
  final bool isLoading;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController categoryController;
  final TextEditingController stockController;
  final List<html.File> imageFiles;
  final VoidCallback onClearInputs;
  final Function(bool) onSetLoading;
  final Function(List<html.File>) onUpdateImageFiles;
  final Future<HomeSettings> Function() fetchHomeSettings;
  final String? token;

  const AdminContentSections({
    super.key,
    required this.selectedTabIndex,
    required this.username,
    required this.isLoading,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    required this.categoryController,
    required this.stockController,
    required this.imageFiles,
    required this.onClearInputs,
    required this.onSetLoading,
    required this.onUpdateImageFiles,
    required this.fetchHomeSettings,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTabIndex) {
      case 0:
        return _AddProductForm(
          username: username,
          isLoading: isLoading,
          titleController: titleController,
          descriptionController: descriptionController,
          priceController: priceController,
          categoryController: categoryController,
          stockController: stockController,
          imageFiles: imageFiles,
          onClearInputs: onClearInputs,
          onSetLoading: onSetLoading,
          onUpdateImageFiles: onUpdateImageFiles,
        );
      case 1:
        return _ManageProductsTable();
      case 2:
        return _ManageOrdersTable();
      case 3:
        return _HomeScreenSettingsForm(
          fetchHomeSettings: fetchHomeSettings,
          token: token,
        );
      default:
        return _AddProductForm(
          username: username,
          isLoading: isLoading,
          titleController: titleController,
          descriptionController: descriptionController,
          priceController: priceController,
          categoryController: categoryController,
          stockController: stockController,
          imageFiles: imageFiles,
          onClearInputs: onClearInputs,
          onSetLoading: onSetLoading,
          onUpdateImageFiles: onUpdateImageFiles,
        );
    }
  }
}

class _AddProductForm extends StatelessWidget {
  final String username;
  final bool isLoading;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController categoryController;
  final TextEditingController stockController;
  final List<html.File> imageFiles;
  final VoidCallback onClearInputs;
  final Function(bool) onSetLoading;
  final Function(List<html.File>) onUpdateImageFiles;

  const _AddProductForm({
    required this.username,
    required this.isLoading,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    required this.categoryController,
    required this.stockController,
    required this.imageFiles,
    required this.onClearInputs,
    required this.onSetLoading,
    required this.onUpdateImageFiles,
  });

  @override
  Widget build(BuildContext context) {
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
            onPressed: isLoading ? null : () => _submitProduct(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      List<html.File> htmlFiles = [];
      for (var pickedFile in pickedFiles) {
        final bytes = await pickedFile.readAsBytes();
        final htmlFile = html.File([bytes], pickedFile.name);
        htmlFiles.add(htmlFile);
      }
      onUpdateImageFiles(htmlFiles);
    }
  }

  Future<void> _submitProduct(BuildContext context) async {
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
      onSetLoading(true);

      try {
        Map<String, dynamic> result = await ProductApiService().addProduct(
          title: title,
          description: description,
          price: price,
          category: category,
          images: imageFiles,
          stock: stock,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        onClearInputs();
      } catch (e) {
        String errorMessage = e.toString().replaceAll('Exception:', '').trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      } finally {
        onSetLoading(false);
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
}

class _ManageProductsTable extends StatefulWidget {
  @override
  State<_ManageProductsTable> createState() => _ManageProductsTableState();
}

class _ManageProductsTableState extends State<_ManageProductsTable> {
  @override
  Widget build(BuildContext context) {
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
              _buildTableHeader(),
              const SizedBox(height: 20),
              Expanded(
                child: _buildProductDataTable(products),
              ),
              _buildPagination(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Row(
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
            _buildActionButton('Filter', Icons.filter_list, () {}),
            const SizedBox(width: 15),
            _buildActionButton('Export', Icons.file_download, _exportProducts),
            const SizedBox(width: 15),
            _buildActionButton('New Product', Icons.add, () {},
                isPrimary: true),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed,
      {bool isPrimary = false}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: isPrimary ? Colors.white : Colors.black),
      label: Text(label,
          style: TextStyle(color: isPrimary ? Colors.white : Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primaryColor : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildProductDataTable(List<Product> products) {
    return Container(
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
            headingRowColor: WidgetStateProperty.all(AppColors.secondaryColor),
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
                  DataCell(_buildProductCell(product)),
                  DataCell(Text(product.stock.toString())),
                  DataCell(Text('\$${product.price}')),
                  DataCell(Text(product.category)),
                  DataCell(_buildActionButtons(product, products)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCell(Product product) {
    return Row(
      children: [
        Image.network(
          product.images.isNotEmpty
              ? product.images[0]
              : 'assets/images/medical.png',
          width: 50,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 50,
              height: 50,
              color: Colors.grey.shade200,
              child: const Icon(Icons.image_not_supported),
            );
          },
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                product.title,
                style: GoogleFonts.poppins(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product.description,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Product product, List<Product> products) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 20),
          onPressed: () => _editProduct(products, products.indexOf(product)),
          color: Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: () => _deleteProduct(products, products.indexOf(product)),
          color: AppColors.primaryColor,
        ),
      ],
    );
  }

  Widget _buildPagination() {
    return Padding(
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
    );
  }

  void _exportProducts() {
    ProductApiService().fetchProducts().then((fetchedProducts) {
      final products =
          fetchedProducts.map((product) => Product.fromJson(product)).toList();
      _generateAndDownloadPdf(products
          .map((product) => {
                'id': product.id,
                'name': product.title,
                'price': product.price,
              })
          .toList());
    }).catchError((error) {
      print('Error fetching products: $error');
    });
  }

  Future<void> _generateAndDownloadPdf(
      List<Map<String, dynamic>> products) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Product Data', style: const pw.TextStyle(fontSize: 24)),
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

  void _editProduct(List<Product> products, int index) {
    final product = products[index];
    final titleController = TextEditingController(text: product.title);
    final descriptionController =
        TextEditingController(text: product.description);
    final priceController =
        TextEditingController(text: product.price.toString());
    final categoryController = TextEditingController(text: product.category);
    final stockController =
        TextEditingController(text: product.stock.toString());

    List<html.File> updatedImages = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Product'),
              content: SizedBox(
                width: double.maxFinite,
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: categoryController,
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: stockController,
                        decoration:
                            const InputDecoration(labelText: 'Stock Quantity'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFiles = await picker.pickMultiImage();
                          if (pickedFiles.isNotEmpty) {
                            List<html.File> htmlFiles = [];
                            for (var pickedFile in pickedFiles) {
                              final bytes = await pickedFile.readAsBytes();
                              final htmlFile =
                                  html.File([bytes], pickedFile.name);
                              htmlFiles.add(htmlFile);
                            }
                            setDialogState(() {
                              updatedImages = htmlFiles;
                            });
                          }
                        },
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.secondaryColor.withOpacity(0.8),
                          ),
                          child: updatedImages.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: updatedImages.length,
                                  itemBuilder: (context, index) {
                                    final imageFile = updatedImages[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
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
                                    Text(
                                        "Tap to upload or drag and drop files"),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel',
                      style: TextStyle(color: AppColors.primaryColor)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      double price =
                          double.tryParse(priceController.text) ?? 0.0;
                      int stock = int.tryParse(stockController.text) ?? 0;

                      List<html.File> fallbackImages = [];
                      if (product.images.isNotEmpty) {
                        for (var imageName in product.images) {
                          final placeholderBytes = Uint8List(0);
                          final htmlFile =
                              html.File([placeholderBytes], imageName);
                          fallbackImages.add(htmlFile);
                        }
                      }

                      await ProductApiService().editProduct(
                        productId: product.id,
                        title: titleController.text,
                        description: descriptionController.text,
                        price: price,
                        category: categoryController.text,
                        images: updatedImages.isNotEmpty
                            ? updatedImages
                            : fallbackImages,
                        stock: stock,
                      );

                      setState(() {
                        product.title = titleController.text;
                        product.description = descriptionController.text;
                        product.price = price;
                        product.category = categoryController.text;
                        product.stock = stock;
                        if (updatedImages.isNotEmpty) {
                          product.images =
                              updatedImages.map((file) => file.name).toList();
                        }
                      });

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Product updated successfully!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: AppColors.primaryColor,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor),
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteProduct(List<Product> products, int index) async {
    final productId = products[index].id;
    try {
      await ProductApiService().deleteProduct(productId);
      setState(() {
        products.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _ManageOrdersTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrdersHeader(),
          const SizedBox(height: 20),
          _buildOrdersStatusTabs(),
          const SizedBox(height: 20),
          Expanded(child: _buildOrdersDataTable()),
          _buildOrdersPagination(),
        ],
      ),
    );
  }

  Widget _buildOrdersHeader() {
    return Row(
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
            _buildOrderActionButton('Filter', Icons.filter_list, () {}),
            const SizedBox(width: 15),
            _buildOrderActionButton('Export', Icons.file_download, () {}),
            const SizedBox(width: 15),
            _buildOrderActionButton('New Product', Icons.add, () {},
                isPrimary: true),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderActionButton(
      String label, IconData icon, VoidCallback onPressed,
      {bool isPrimary = false}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: isPrimary ? Colors.white : Colors.black),
      label: Text(label,
          style: TextStyle(color: isPrimary ? Colors.white : Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primaryColor : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildOrdersStatusTabs() {
    return Row(
      children: [
        _buildStatusTab('All Orders (644)', true),
        _buildStatusTab('Shipping (100)', false),
        _buildStatusTab('Completed (500)', false),
        _buildStatusTab('Cancel (0)', false),
      ],
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

  Widget _buildOrdersDataTable() {
    return Container(
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
          data: ThemeData().copyWith(dividerColor: Colors.grey.shade200),
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
            dataTextStyle:
                GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            headingRowColor: WidgetStateProperty.all(AppColors.secondaryColor),
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
              final isPaid = (index % 3 == 0);
              final isCanceled = (index % 4 == 0);
              return DataRow(
                cells: [
                  DataCell(_buildOrderCell(index)),
                  const DataCell(Text('Ahmed Mohamed')),
                  const DataCell(Text('\$12.78')),
                  const DataCell(Text('24/07/23')),
                  DataCell(_buildStatusChip(
                    isPaid ? 'Paid' : 'Unpaid',
                    isPaid ? Colors.green.shade50 : Colors.orange.shade50,
                    isPaid ? Colors.green : Colors.orange,
                  )),
                  DataCell(_buildStatusChip(
                    isCanceled ? 'Canceled' : 'Shipped',
                    isCanceled ? Colors.red.shade50 : Colors.purple.shade50,
                    isCanceled ? Colors.red : Colors.purple,
                  )),
                  DataCell(_buildOrderActionButtons()),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCell(int index) {
    return Row(
      children: [
        Image.asset('assets/images/medical.png', width: 50),
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
            const Text('Dental Instrument name'),
          ],
        ),
      ],
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

  Widget _buildOrderActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 20),
          onPressed: () {},
          color: Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: () {},
          color: AppColors.primaryColor,
        ),
      ],
    );
  }

  Widget _buildOrdersPagination() {
    return Padding(
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
    );
  }
}

class _HomeScreenSettingsForm extends StatelessWidget {
  final Future<HomeSettings> Function() fetchHomeSettings;
  final String? token;

  const _HomeScreenSettingsForm({
    required this.fetchHomeSettings,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeSettings>(
      future: fetchHomeSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data found.'));
        }

        final settings = snapshot.data!;
        return _HomeSettingsContent(
          settings: settings,
          token: token,
        );
      },
    );
  }
}

class _HomeSettingsContent extends StatefulWidget {
  final HomeSettings settings;
  final String? token;

  const _HomeSettingsContent({
    required this.settings,
    required this.token,
  });

  @override
  State<_HomeSettingsContent> createState() => _HomeSettingsContentState();
}

class _HomeSettingsContentState extends State<_HomeSettingsContent> {
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  html.File? selectedBannerImage;
  String? currentBannerUrl;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.settings.homeTitle);
    subtitleController =
        TextEditingController(text: widget.settings.homeSubtitle);
    currentBannerUrl = widget.settings.homeBanner;
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Manage Home Screen",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildSettingCard("Home Title", titleController),
          const SizedBox(height: 20),
          _buildSettingCard("Home Subtitle", subtitleController),
          const SizedBox(height: 20),
          _buildBannerUploadCard(),
          const SizedBox(height: 30),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildSettingCard(String label, TextEditingController controller) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      shadowColor: AppColors.primaryColor.withOpacity(0.4),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: _labelTextStyle()),
            const SizedBox(height: 8),
            _styledTextField(controller: controller),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerUploadCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      shadowColor: AppColors.primaryColor.withOpacity(0.4),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Banner Image", style: _labelTextStyle()),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(
                    "Max 2MB",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildBannerUploader(),
            if (currentBannerUrl != null &&
                currentBannerUrl!.isNotEmpty &&
                selectedBannerImage == null) ...[
              const SizedBox(height: 16),
              Text(
                "Current Banner:",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              _buildCurrentBannerPreview(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBannerUploader() {
    return GestureDetector(
      onTap: isSaving ? null : _pickBannerImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.6),
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.secondaryColor.withOpacity(0.3),
        ),
        child: selectedBannerImage != null
            ? _buildSelectedImagePreview()
            : _buildUploadPlaceholder(),
      ),
    );
  }

  Widget _buildSelectedImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            html.Url.createObjectUrl(selectedBannerImage!),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              onPressed: isSaving
                  ? null
                  : () {
                      setState(() {
                        selectedBannerImage = null;
                      });
                    },
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  "New Banner Selected",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          color: AppColors.primaryColor,
          size: 48,
        ),
        const SizedBox(height: 12),
        Text(
          "Upload Banner Image",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Click to select an image file\nRecommended: 1200x400px",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
          ),
          child: Text(
            "JPEG, PNG, JPG, GIF up to 2MB",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentBannerPreview() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              currentBannerUrl!, 
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image,
                          color: Colors.grey.shade400, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        "Failed to load current banner",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade100,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Current",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      shadowColor: AppColors.primaryColor.withOpacity(0.6),
      color: AppColors.primaryColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: isSaving ? null : _saveSettings,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.center,
          child: isSaving
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Saving Settings...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : const Text(
                  "Save Settings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
        ),
      ),
    );
  }

  TextStyle _labelTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Color(0xFF8B0000),
    );
  }

  Widget _styledTextField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: AppColors.secondaryColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.primaryColor.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
    );
  }

  Future<void> _pickBannerImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 400,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        if (bytes.length > 2 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image size should be less than 2MB'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        final fileName = pickedFile.name.toLowerCase();
        final allowedExtensions = ['jpeg', 'jpg', 'png', 'gif'];
        final isValidType =
            allowedExtensions.any((ext) => fileName.endsWith('.$ext'));

        if (!isValidType) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Please select a valid image file (JPEG, PNG, JPG, GIF)'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        final htmlFile = html.File([bytes], pickedFile.name);
        setState(() {
          selectedBannerImage = htmlFile;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Home title is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (subtitleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Home subtitle is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() {
        isSaving = true;
      });

      var request = http.MultipartRequest(
        'post',
        Uri.parse('http://127.0.0.1:8000/api/settings/home'),
      );

      if (widget.token != null) {
        request.headers['Authorization'] = 'Bearer ${widget.token}';
      }

      request.fields['home_title'] = titleController.text.trim();
      request.fields['home_subtitle'] = subtitleController.text.trim();

      if (selectedBannerImage != null) {
        final bytes = await _fileToBytes(selectedBannerImage!);
        request.files.add(
          http.MultipartFile.fromBytes(
            'home_banner', 
            bytes,
            filename: selectedBannerImage!.name,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (selectedBannerImage != null) {
          await _refreshSettings();
        }

        setState(() {
          selectedBannerImage = null; 
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  responseData['message'] ?? 'Settings updated successfully!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update settings');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving settings: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _refreshSettings() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/settings/home'),
        headers: {
          if (widget.token != null) "Authorization": "Bearer ${widget.token}",
        },
      );

      if (response.statusCode == 200) {
        final settings = HomeSettings.fromJson(json.decode(response.body));
        setState(() {
          currentBannerUrl = settings.homeBanner;
          titleController.text = settings.homeTitle;
          subtitleController.text = settings.homeSubtitle;
        });
      }
    } catch (e) {
      print('Error refreshing settings: $e');
    }
  }

  Future<Uint8List> _fileToBytes(html.File file) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;
    return reader.result as Uint8List;
  }
}
