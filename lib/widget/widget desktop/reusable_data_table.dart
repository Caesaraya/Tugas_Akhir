import 'package:flutter/material.dart';

class ReusableDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final String? emptyMessage;
  final Widget? emptyWidget;
  final double? columnSpacing;
  final Color? headingRowColor;
  final bool showBorders;

  const ReusableDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyMessage = 'Tidak ada data',
    this.emptyWidget,
    this.columnSpacing = 20,
    this.headingRowColor,
    this.showBorders = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: rows.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              child: DataTable(
                columnSpacing: columnSpacing,
                headingRowColor: headingRowColor != null
                    ? WidgetStateProperty.all(headingRowColor)
                    : WidgetStateProperty.all(Colors.grey.shade300),
                border: showBorders
                    ? TableBorder.all(color: Colors.grey.shade300)
                    : null,
                columns: columns,
                rows: rows,
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    if (emptyWidget != null) {
      return Center(child: emptyWidget);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_chart_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage!,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
