import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/widget/admin/table/table_toolbar.dart';

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
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductDetailImage(product: product),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductDetailHeader(product: product),
                  const SizedBox(height: 10),
                  if (product.discount > 0)
                    ProductPriceDiscount(product: product, currency: currency),
                  Text(
                    currency.format(product.priceAfterDiscount),
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xFF5D4037),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Informasi Produk',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  InfoRow(label: 'Jenis', value: product.jenis),
                  InfoRow(label: 'Satuan', value: product.satuan),
                  InfoRow(label: 'Stok Sistem', value: '${product.stock} pcs'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailImage extends StatelessWidget {
  final Product product;
  const ProductDetailImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      color: Colors.grey[100],
      child: product.image.isNotEmpty
          ? Image.network(
              product.image,
              fit: product.image.startsWith('http')
                  ? BoxFit.cover
                  : BoxFit.contain,
            )
          : const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
    );
  }
}

class ProductDetailHeader extends StatelessWidget {
  final Product product;
  const ProductDetailHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            product.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // Memberikan efek coret jika produk dalam status terhapus (Soft Deleted)
              decoration: product.isDeleted ? TextDecoration.lineThrough : null,
              color: product.isDeleted ? Colors.grey : Colors.black,
            ),
          ),
        ),
        if (product.isDeleted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'DIHAPUS',
              style: TextStyle(
                color: Colors.red.shade800,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

class ProductPriceDiscount extends StatelessWidget {
  final Product product;
  final NumberFormat currency;

  const ProductPriceDiscount({
    super.key,
    required this.product,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${product.discount}%',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12,
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
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ==========================================
// BAGIAN UTAMA YANG DIUBAH / DISELARASKAN
// ==========================================
class ProductDetailActions extends StatelessWidget {
  final Product product;
  final ProductTableController controller;

  const ProductDetailActions({
    super.key,
    required this.product,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: product.isDeleted
            ? [
                // JIKA PRODUK SUDAH DIHAPUS (SOFT DELETED): Sediakan Opsi Pulihkan & Hapus Permanen
                Expanded(
                  child: ToolbarButton(
                    title: 'Pulihkan',
                    icon: Icons.restore_rounded,
                    color: Colors.green,
                    onTap: () async {
                      await controller.restoreProduct(product.id);
                      Get.back(); // Otomatis kembali ke list setelah berhasil dipulihkan
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ToolbarButton(
                    title: 'Hapus Permanen',
                    icon: Icons.delete_forever_rounded,
                    color: Colors.red.shade900,
                    onTap: () async {
                      await controller.forceDeleteProduct(product.id);
                      Get.back(); // Otomatis kembali ke list setelah berhasil dihapus permanen
                    },
                  ),
                ),
              ]
            : [
                // JIKA PRODUK AKTIF: Sediakan Opsi Edit & Hapus (Soft Delete)
                Expanded(
                  child: ToolbarButton(
                    title: 'Edit',
                    icon: Icons.edit_outlined,
                    color: const Color(0xFF5D4037),
                    onTap: () => controller.openEditDialog(product),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ToolbarButton(
                    title: 'Hapus',
                    icon: Icons.delete_outline,
                    color: Colors.red,
                    onTap: () async {
                      await controller.softDeleteProduct(product.id);
                      // Tidak menggunakan Get.back() di sini karena dialog konfirmasi
                      // dari softDeleteProduct() di controller yang akan mengontrol alur perpindahan layar.
                    },
                  ),
                ),
              ],
      ),
    );
  }
}