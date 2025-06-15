import 'package:DentaCarts/widgets/admin/components/orders_data_table.dart';
import 'package:DentaCarts/widgets/admin/components/orders_status_tabs.dart';
import 'package:DentaCarts/widgets/admin/components/orders_table_header.dart';
import 'package:DentaCarts/widgets/admin/components/table_pagination.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:DentaCarts/core/app_colors.dart';

class ManageOrdersTable extends StatelessWidget {
  const ManageOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrdersTableHeader(),
          SizedBox(height: 20),
          OrdersStatusTabs(),
          SizedBox(height: 20),
          Expanded(child: OrdersDataTable()),
          TablePagination(),
        ],
      ),
    );
  }
}
