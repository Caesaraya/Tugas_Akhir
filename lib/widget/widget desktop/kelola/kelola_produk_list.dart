import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/kelola_controller.dart';
import 'package:tugas_akhir/widget/widget%20desktop/kelola/product_card_kelola.dart';

class KelolaProdukList extends StatelessWidget {
  final KelolaProdukController ctrl;
 
  const KelolaProdukList({super.key, required this.ctrl});
 
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFE89336)),
        );
      }
      if (ctrl.filteredProducts.isEmpty) {
        return const Center(
          child: Text(
            'Produk tidak ditemukan',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: ctrl.fetchData,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: ctrl.filteredProducts.length,
          itemBuilder: (context, index) {
            final produk = ctrl.filteredProducts[index];
            // Pakai widget yang sama dengan desktop
            return ProductCardKelola(ctrl: ctrl, produk: produk);
          },
        ),
      );
    });
  }
}