import 'package:DentaCarts/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _selectedImage;
  int _selectedTabIndex = 0;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
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
            children: const [
              TextSpan(
                text: "\nAhmed!",
                style: TextStyle(
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
        _buildTextField("Product Title", Icons.title),
        _buildTextField("Product Description", Icons.description),
        _buildTextField("Price", Icons.attach_money),
        _buildTextField("Category", Icons.category),
        _buildTextField("Stock Quantity", Icons.numbers),
        _buildImageUploader(),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text(
              "Submit Product",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
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
          child: _selectedImage != null
              ? Image.file(_selectedImage!, fit: BoxFit.cover)
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
                    onPressed: () {},
                    icon: const Icon(Icons.file_download, color: Colors.black),
                    label: const Text('Export',
                        style: TextStyle(color: Colors.black)),
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
