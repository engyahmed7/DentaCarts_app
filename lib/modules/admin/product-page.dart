import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:html' as html;
import 'package:fl_chart/fl_chart.dart';

import 'package:image_picker_web/image_picker_web.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import '../../controller/Auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(const ProductAdminPanel());
}

class ProductAdminPanel extends StatefulWidget {
  const ProductAdminPanel({super.key});

  @override
  _ProductAdminPanelState createState() => _ProductAdminPanelState();
}

class _ProductAdminPanelState extends State<ProductAdminPanel> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ProductForm(),
    const ManageProductsPage(),
    const ProductStatisticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Product Admin Panel'),
          centerTitle: true,
          elevation: 0,
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Product',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Manage Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistics',
            ),
          ],
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
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
  final _categoryController = TextEditingController();
  final _stockController = TextEditingController();
  Uint8List? _imageData;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    if (bytesFromPicker != null) {
      setState(() {
        _imageData = bytesFromPicker;
      });
    }
  }

Future<void> _submitProduct() async {
  final authCubit = BlocProvider.of<AuthCubit>(context); 
  setState(() {
    _isLoading = true;
  });

  if (_formKey.currentState!.validate() && _imageData != null) {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:3000/products/'),
    );
    request.fields['title'] = _titleController.text;
    request.fields['description'] = _descController.text;
    request.fields['price'] = _priceController.text;
    request.fields['category'] = _categoryController.text;
    request.fields['stock'] = _stockController.text;

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',  
        _imageData!, 
        filename: 'product_image.png',  
        contentType: MediaType('image', 'png'), 
      ),
    );
    request.headers['Authorization'] = 'Bearer ${authCubit.token}'; 

    debugPrint('Request fields: ${request.fields}');
    debugPrint('Product token: ${authCubit.token}');

    final response = await request.send();

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
          backgroundColor: Colors.teal,
        ),
      );
    } else {
      final responseBody = await response.stream.bytesToString();
      debugPrint('Error response: $responseBody');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add product.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select an image.'),
        backgroundColor: Colors.red,
      ),
    );
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
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                filled: true,
                prefixIcon: Icon(Icons.category, color: Colors.teal),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the category';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'Stock Quantity',
                filled: true,
                prefixIcon: Icon(Icons.storage, color: Colors.teal),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the stock quantity';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid integer';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            if (_imageData != null)
              Image.memory(
                _imageData!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Center(
                child: ElevatedButton(
                  onPressed: _submitProduct,
                  child: const Text('Submit Product'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}





class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  _ManageProductsPageState createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://dummyjson.com/products'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          products = List<Map<String, dynamic>>.from(data['products']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _editProduct(int index) {
    final product = products[index];
    TextEditingController titleController =
        TextEditingController(text: product['title']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController thumbnailController =
        TextEditingController(text: product['thumbnail']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: thumbnailController,
                decoration: const InputDecoration(labelText: 'Thumbnail URL'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Pick Thumbnail Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  products[index]['title'] = titleController.text;
                  products[index]['price'] = double.parse(priceController.text);
                  products[index]['thumbnail'] = thumbnailController.text;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Product updated successfully!')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: Image.network(
                    product['thumbnail'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product['title']),
                  subtitle: Text(
                    'Price: \$${product['price'].toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.teal),
                        onPressed: () {
                          _editProduct(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteProduct(index);
                        },
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 1.0,
                  height: 10.0,
                  color: Colors.grey,
                );
              },
            ),
    );
  }
}

class ProductStatisticsPage extends StatefulWidget {
  const ProductStatisticsPage({super.key});

  @override
  _ProductStatisticsPageState createState() => _ProductStatisticsPageState();
}

class _ProductStatisticsPageState extends State<ProductStatisticsPage> {
  List<ProductSales> productSales = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductSales();
  }

  Future<void> fetchProductSales() async {
    try {
      final response =
          await http.get(Uri.parse('https://dummyjson.com/products'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          productSales = (data['products'] as List)
              .map((item) => ProductSales.fromJson(item))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load product sales');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Stock Statistics',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: productSales
                            .map((e) => e.stock)
                            .reduce((a, b) => a > b ? a : b)
                            .toDouble(),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.blueGrey,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${productSales[group.x].productName}\n${rod.toY.round()} stock',
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < productSales.length) {
                                  return SizedBox(
                                    width: 50,
                                    child: Text(
                                      productSales[value.toInt()].productName,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.visible,
                                      maxLines: 2,
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: productSales
                            .asMap()
                            .entries
                            .map(
                              (entry) => BarChartGroupData(
                                x: entry.key,
                                barRods: [
                                  BarChartRodData(
                                    toY: entry.value.stock.toDouble(),
                                    color: Colors.teal,
                                    width: 16,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ProductSales {
  final String productName;
  final int stock;

  ProductSales({required this.productName, required this.stock});

  factory ProductSales.fromJson(Map<String, dynamic> json) {
    return ProductSales(
      productName: json['title'],
      stock: json['stock'],
    );
  }
}
