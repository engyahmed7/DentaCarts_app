import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/admin/services/product_api_service.dart';

class AddProductForm extends StatelessWidget {
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

  const AddProductForm({
    super.key,
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
        _buildWelcomeHeader(),
        const SizedBox(height: 30),
        _buildSectionTitle(),
        const SizedBox(height: 20),
        _buildFormFields(),
        _buildImageUploader(),
        const SizedBox(height: 20),
        _buildSubmitButton(context),
      ],
    );
  }

  Widget _buildWelcomeHeader() {
    return RichText(
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
    );
  }

  Widget _buildSectionTitle() {
    return Text(
      "Add New Product",
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField("Product Title", Icons.title, titleController),
        _buildTextField(
            "Product Description", Icons.description, descriptionController),
        _buildTextField("Price", Icons.attach_money, priceController),
        _buildTextField("Category", Icons.category, categoryController),
        _buildTextField("Stock Quantity", Icons.numbers, stockController),
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
              ? _buildImagePreview()
              : _buildUploadPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return ListView.builder(
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
    );
  }

  Widget _buildUploadPlaceholder() {
    return const Column(
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
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
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
        await ProductApiService().addProduct(
          title: title,
          description: description,
          price: price,
          category: category,
          images: imageFiles,
          stock: stock,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }

        onClearInputs();
      } catch (e) {
        if (context.mounted) {
          String errorMessage =
              e.toString().replaceAll('Exception:', '').trim();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: const Duration(seconds: 2),
              backgroundColor: AppColors.primaryColor,
            ),
          );
        }
      } finally {
        onSetLoading(false);
      }
    } else {
      if (context.mounted) {
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
}
