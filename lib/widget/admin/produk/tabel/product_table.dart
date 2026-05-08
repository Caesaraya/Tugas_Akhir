// lib/views/widgets/product/product_table.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/produk_admin_controller.dart';
import 'package:tugas_akhir/widget/admin/produk/tabel/product_table_header.dart';
import 'package:tugas_akhir/widget/admin/produk/tabel/product_table_row.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({super.key, required this.ctrl});

  final ProductController ctrl;

  static const List<String> _columns = [
    'ID',
    'Nama Produk',
    'Harga',
    'Stok',
    'Diskon',
    'Aksi',
  ];

  // null = Expanded (flexible), angka = fixed width
  static const List<double?> colWidths = [60.0, null, 130.0, 80.0, 80.0, 140.0];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // ── Header kolom ────────────────────────────
            ProductTableHeader(columns: _columns, colWidths: colWidths),

            // ── List baris data ─────────────────────────
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: ctrl.displayedProducts.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (context, index) {
                    final product = ctrl.displayedProducts[index];
                    return ProductTableRow(
                      product: product,
                      ctrl: ctrl,
                      colWidths: colWidths,
                      isEven: index.isEven,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
