// lib/views/widgets/product/product_empty_state.dart
import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/admin/produk_admin_controller.dart';

class ProductEmptyState extends StatelessWidget {
  const ProductEmptyState({super.key, required this.ctrl});

  final ProductController ctrl;

  @override
  Widget build(BuildContext context) {
    final String message;

    if (ctrl.isFilteringOutOfStock.value) {
      message = 'Tidak ada produk dengan stok habis';
    } else if (ctrl.searchQuery.value.isNotEmpty) {
      message = 'Produk "${ctrl.searchQuery.value}" tidak ditemukan';
    } else {
      message = 'Belum ada produk';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: ctrl.fetchProducts,
            icon: const Icon(Icons.refresh),
            label: const Text('Muat Ulang'),
          ),
        ],
      ),
    );
  }
}
