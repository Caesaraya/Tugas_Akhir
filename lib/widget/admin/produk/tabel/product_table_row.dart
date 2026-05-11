// lib/views/widgets/product/product_table_row.dart
import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/admin/produk_admin_controller.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/widget/admin/table_action_button.dart';

class ProductTableRow extends StatelessWidget {
  const ProductTableRow({
    super.key,
    required this.product,
    required this.ctrl,
    required this.colWidths,
    required this.isEven,
  });

  final Product product;
  final ProductAdminController ctrl;
  final List<double?> colWidths;
  final bool isEven;

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = product.stock <= 0;
    final hasDiscount = product.discount > 0;

    return Container(
      color: isEven ? Colors.white : const Color(0xFFFAFBFC),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // ── ID ─────────────────────────────────────────
          SizedBox(
            width: colWidths[0],
            child: Text(
              'TR${product.id}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),

          // ── Nama Produk ────────────────────────────────
          Expanded(
            child: Text(
              product.name,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ── Harga ──────────────────────────────────────
          SizedBox(
            width: colWidths[2],
            child: Text(
              ctrl.formatRupiah(product.price),
              style: const TextStyle(fontSize: 13),
            ),
          ),

          // ── Stok ───────────────────────────────────────
          SizedBox(
            width: colWidths[3],
            child: isOutOfStock
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5722),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Habis',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Text(
                    '${product.stock}',
                    style: const TextStyle(fontSize: 13),
                  ),
          ),

          // ── Diskon ─────────────────────────────────────
          SizedBox(
            width: colWidths[4],
            child: Text(
              hasDiscount ? '${product.discount.toInt()}%' : '0',
              style: TextStyle(
                fontSize: 13,
                color: hasDiscount
                    ? Colors.orange.shade700
                    : Colors.grey.shade600,
                fontWeight: hasDiscount ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),

          // ── Aksi ───────────────────────────────────────
          SizedBox(
            width: colWidths[5],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProductTableActionButton(
                  label: 'Hapus',
                  color: const Color(0xFFE53935),
                  onPressed: () => ctrl.confirmDelete(product),
                ),
                const SizedBox(width: 6),
                ProductTableActionButton(
                  label: 'Edit',
                  color: const Color(0xFF1E88E5),
                  onPressed: () => ctrl.showEditDialog(product),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
