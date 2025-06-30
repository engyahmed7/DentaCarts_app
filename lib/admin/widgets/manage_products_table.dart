import 'package:DentaCarts/admin/widgets/components/product_data_table.dart';
import 'package:DentaCarts/admin/widgets/components/product_table_header.dart';
import 'package:DentaCarts/admin/widgets/components/table_pagination.dart';
import 'package:DentaCarts/admin/widgets/dialogs/edit_product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:DentaCarts/admin/services/product_api_service.dart';

class ManageProductsTable extends StatefulWidget {
  const ManageProductsTable({super.key});

  @override
  State<ManageProductsTable> createState() => _ManageProductsTableState();
}

class _ManageProductsTableState extends State<ManageProductsTable> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _fetchProducts(),
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
              ProductTableHeader(onExport: () => _exportProducts(products)),
              const SizedBox(height: 20),
              Expanded(
                child: ProductDataTable(
                  products: products,
                  onEdit: _editProduct,
                  onDelete: _deleteProduct,
                ),
              ),
              const TablePagination(),
            ],
          ),
        );
      },
    );
  }

  Future<List<Product>> _fetchProducts() async {
    final fetchedProducts = await ProductApiService().fetchProducts();
    return fetchedProducts.map((product) => Product.fromJson(product)).toList();
  }

  void _exportProducts(List<Product> products) {
    _generateAndDownloadPdf(products
        .map((product) => {
              'id': product.id,
              'name': product.title,
              'price': product.price,
            })
        .toList());
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
    showDialog(
      context: context,
      builder: (context) => EditProductDialog(
        product: products[index],
        onProductUpdated: (updatedProduct) {
          setState(() {
            products[index] = updatedProduct;
          });
        },
      ),
    );
  }

  void _deleteProduct(List<Product> products, int index) async {
    final productId = products[index].id;
    try {
      await ProductApiService().deleteProduct(productId);
      setState(() {
        products.removeAt(index);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting product: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
