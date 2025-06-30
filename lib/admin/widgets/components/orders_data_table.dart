import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:DentaCarts/core/app_colors.dart';

class OrdersDataTable extends StatelessWidget {
  const OrdersDataTable({super.key});

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
}
