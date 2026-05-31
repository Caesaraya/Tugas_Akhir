import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/page/admin/mobile/produk/product_detail_page.dart';

class ProductItemCard extends StatelessWidget {
  final Product product;
  final ProductTableController controller;
  final NumberFormat formatCurrency;

  const ProductItemCard({
    super.key,
    required this.product,
    required this.controller,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: product.isDeleted ? Colors.red.shade50 : Colors.white, // DIUBAH
        borderRadius: BorderRadius.circular(12),
        border: product.isDeleted
            ? Border.all(color: Colors.red.shade200)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (!product.isDeleted) {
            // Cegah akses detail untuk produk terhapus
            Get.to(() => ProductDetailPage(product: product));
          } else {
            Get.snackbar('Info', 'Produk ini sedang dalam status dihapus.');
          }
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.bakery_dining),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: product.isDeleted
                                ? TextDecoration.lineThrough
                                : null, // Coret nama jika dihapus
                          ),
                        ),
                      ),
                      // DITAMBAHKAN: Badge Mobile
                      if (product.isDeleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'DIHAPUS',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.red.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.jenis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  Text(
                    formatCurrency.format(product.price),
                    style: const TextStyle(
                      color: Color(0xFF5D4037),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Stok: ${product.stock}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: product.isDeleted
                      ? [
                          // DIUBAH: Tombol dinamis
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              Icons.restore_rounded,
                              color: Colors.green,
                              size: 20,
                            ),
                            onPressed: () =>
                                controller.restoreProduct(product.id),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.red.shade900,
                              size: 20,
                            ),
                            onPressed: () =>
                                controller.forceDeleteProduct(product.id),
                          ),
                        ]
                      : [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.blue,
                              size: 20,
                            ),
                            onPressed: () => controller.openEditDialog(product),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () =>
                                controller.softDeleteProduct(product.id),
                          ),
                        ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
