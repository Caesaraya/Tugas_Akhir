import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/models/product.dart';
import '../../custom_network_image.dart';

class ProductDetailBody extends StatelessWidget {
  final Product product;
  final NumberFormat currency;

  const ProductDetailBody({
    super.key,
    required this.product,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final isDeleted = product.deletedAt != null;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              imageUrl: product.image,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              color: isDeleted ? Colors.grey : null,
              colorBlendMode: isDeleted ? BlendMode.saturation : null,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDeleted
                              ? Colors.red.shade100
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isDeleted ? 'Nonaktif' : product.jenis,
                          style: TextStyle(
                            color: isDeleted
                                ? Colors.red.shade800
                                : Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (product.discount > 0) ...[
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${product.discount}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currency.format(product.price),
                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currency.format(product.priceAfterDiscount),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ] else ...[
                    Text(
                      currency.format(product.price),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],

                  const Divider(height: 32),
                  _buildInfoRow(
                    Icons.inventory_2_outlined,
                    'Stok Tersedia',
                    '${product.stock} ${product.satuan}',
                  ),
                  _buildInfoRow(
                    Icons.qr_code_2_rounded,
                    'Barcode Produk',
                    product.barcode,
                  ),
                  _buildInfoRow(
                    Icons.assignment_outlined,
                    'Kategori Alat',
                    product.jenis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class ProductDetailBottomBar extends StatelessWidget {
  final Product product;
  final ProductTableController controller;

  const ProductDetailBottomBar({
    super.key,
    required this.product,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDeleted = product.deletedAt != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => controller.openEditDialog(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Edit Produk',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => isDeleted
                      ? controller.confirmRestore(product.id)
                      : controller.confirmSoftDelete(product.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDeleted ? Colors.green : Colors.red,
                    side: BorderSide(
                      color: isDeleted
                          ? Colors.green.shade200
                          : const Color(0xFFFFCDD2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isDeleted ? 'Pulihkan' : 'Hapus',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
