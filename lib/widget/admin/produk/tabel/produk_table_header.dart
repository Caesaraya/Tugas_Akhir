// lib/views/widgets/product/product_table_header.dart
import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({
    super.key,
    required this.columns,
    required this.colWidths,
  });

  final List<String> columns;
  final List<double?> colWidths;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F2F5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(columns.length, (i) {
          final cell = Text(
            columns[i],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF444444),
            ),
          );
          final width = colWidths[i];
          return width != null
              ? SizedBox(width: width, child: cell)
              : Expanded(child: cell);
        }),
      ),
    );
  }
}
