import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:DentaCarts/admin/services/product_api_service.dart';

import 'package:DentaCarts/admin/html_stub.dart'
if (dart.library.html) 'dart:html' as html;

class EditProductDialog extends StatefulWidget {
  final Product product;
  final Function(Product) onProductUpdated;

  const EditProductDialog({
    super.key,
    required this.product,
    required this.onProductUpdated,
  });

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController categoryController;
  late TextEditingController stockController;
  List<html.File> updatedImages = [];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.product.title);
    descriptionController =
        TextEditingController(text: widget.product.description);
    priceController =
        TextEditingController(text: widget.product.price.toString());
    categoryController = TextEditingController(text: widget.product.category);
    stockController =
        TextEditingController(text: widget.product.stock.toString());
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    categoryController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Product'),
      content: SizedBox(
        width: double.maxFinite,
        height: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Title', titleController),
              const SizedBox(height: 10),
              _buildTextField('Description', descriptionController),
              const SizedBox(height: 10),
              _buildTextField('Price', priceController, TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField('Category', categoryController),
              const SizedBox(height: 10),
              _buildTextField(
                  'Stock Quantity', stockController, TextInputType.number),
              const SizedBox(height: 10),
              _buildImageUploader(),
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
          onPressed: _saveProduct,
          style:
              ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      [TextInputType? keyboardType]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildImageUploader() {
    return GestureDetector(
      onTap: _pickImages,
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
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      List<html.File> htmlFiles = [];
      for (var pickedFile in pickedFiles) {
        final bytes = await pickedFile.readAsBytes();
        final htmlFile = html.File([bytes], pickedFile.name);
        htmlFiles.add(htmlFile);
      }
      setState(() {
        updatedImages = htmlFiles;
      });
    }
  }

  Future<void> _saveProduct() async {
    try {
      double price = double.tryParse(priceController.text) ?? 0.0;
      int stock = int.tryParse(stockController.text) ?? 0;

      List<html.File> fallbackImages = [];
      if (widget.product.images.isNotEmpty) {
        for (var imageName in widget.product.images) {
          final placeholderBytes = Uint8List(0);
          final htmlFile = html.File([placeholderBytes], imageName);
          fallbackImages.add(htmlFile);
        }
      }

      await ProductApiService().editProduct(
        productId: widget.product.id,
        title: titleController.text,
        description: descriptionController.text,
        price: price,
        category: categoryController.text,
        images: updatedImages.isNotEmpty ? updatedImages : fallbackImages,
        stock: stock,
      );

      final updatedProduct = Product(
        id: widget.product.id,
        title: titleController.text,
        description: descriptionController.text,
        price: price,
        category: categoryController.text,
        stock: stock,
        images: updatedImages.isNotEmpty
            ? updatedImages.map((file) => file.name).toList()
            : widget.product.images,
        rating: widget.product.rating,
        reviews: widget.product.reviews,
      );

      widget.onProductUpdated(updatedProduct);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    }
  }
}
