import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:DentaCarts/model/homeModel.dart';
import 'package:DentaCarts/admin/widgets/admin_sidebar.dart';
import 'package:DentaCarts/admin/widgets/admin_content_sections.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;




class AddProductScreenAdmin extends StatefulWidget {
  const AddProductScreenAdmin({super.key});

  @override
  State<AddProductScreenAdmin> createState() => _AddProductScreenAdminState();
}

class _AddProductScreenAdminState extends State<AddProductScreenAdmin> {
  int _selectedTabIndex = 0;
  String? token;
  String username = '';
  bool _isLoading = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  List<html.File> imageFiles = [];

  @override
  void initState() {
    super.initState();
    _loadUsername();
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

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        username = decodedToken['username'] ?? 'User';
        this.token = token;
      });
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
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

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _updateImageFiles(List<html.File> files) {
    setState(() {
      imageFiles = files;
    });
  }

  Future<HomeSettings> fetchHomeSettings() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/settings/home'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return HomeSettings.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(
            selectedTabIndex: _selectedTabIndex,
            onTabChanged: _onTabChanged,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(80.0),
              child: AdminContentSections(
                selectedTabIndex: _selectedTabIndex,
                username: username,
                isLoading: _isLoading,
                titleController: titleController,
                descriptionController: descriptionController,
                priceController: priceController,
                categoryController: categoryController,
                stockController: stockController,
                imageFiles: imageFiles,
                onClearInputs: _clearInputs,
                onSetLoading: _setLoading,
                onUpdateImageFiles: _updateImageFiles,
                fetchHomeSettings: fetchHomeSettings,
                token: token,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
