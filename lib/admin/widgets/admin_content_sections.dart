import 'package:DentaCarts/admin/widgets/add_product_form.dart';
import 'package:DentaCarts/admin/widgets/home_screen_settings_form.dart';
import 'package:DentaCarts/admin/widgets/manage_orders_table.dart';
import 'package:DentaCarts/admin/widgets/manage_products_table.dart';
import 'package:DentaCarts/admin/widgets/manage_shipping_table.dart';
import 'package:flutter/material.dart';
import 'package:DentaCarts/model/homeModel.dart';
import 'package:DentaCarts/admin/html_stub.dart'
if (dart.library.html) 'dart:html' as html;

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
        return AddProductForm(
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
        return const ManageProductsTable();
      case 2:
        return const ManageOrdersTable();
      case 3:
        return HomeScreenSettingsForm(
          fetchHomeSettings: fetchHomeSettings,
          token: token,
        );
      case 4:
        return ManageShippingTable();
      default:
        return AddProductForm(
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
