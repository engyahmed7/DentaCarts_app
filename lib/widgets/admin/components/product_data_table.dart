import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/model/product_model.dart';

class ProductDataTable extends StatelessWidget {
  final List<Product> products;
  final Function(List<Product>, int) onEdit;
  final Function(List<Product>, int) onDelete;

  const ProductDataTable({
    super.key,
    required this.products,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                  DataCell(Text(_formatPrice(product.price))),
                  DataCell(Text(product.category)),
                  DataCell(_buildActionButtons(product)),
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
        _buildProductImage(product),
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
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductImage(Product product) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: product.images.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.images[0],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            )
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey.shade400,
        size: 24,
      ),
    );
  }

  Widget _buildActionButtons(Product product) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 20),
          onPressed: () => onEdit(products, products.indexOf(product)),
          color: Colors.grey,
          tooltip: 'Edit Product',
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: () => onDelete(products, products.indexOf(product)),
          color: AppColors.primaryColor,
          tooltip: 'Delete Product',
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }
}
