import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/kelola_controller.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/desktop_navigation_drawer.dart';
import 'package:tugas_akhir/widget/widget desktop/kelola/product_card_kelola.dart';

class KasirKelolaDashboard extends StatelessWidget {
  const KasirKelolaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final KelolaProdukController kelolaProdukController =
        Get.find<KelolaProdukController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      drawer: const DesktopNavigationDrawer(),
      appBar: AppBar(
        title: const Text(
          'Kelola Produk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE89336),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: kelolaProdukController.fetchData,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) =>
                  kelolaProdukController.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: 'Cari Produk...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFE89336)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (kelolaProdukController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFE89336)),
                );
              }
              if (kelolaProdukController.filteredProducts.isEmpty) {
                return const Center(
                  child: Text(
                    'Produk tidak ditemukan',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: kelolaProdukController.fetchData,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: kelolaProdukController.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final produk =
                        kelolaProdukController.filteredProducts[index];
                    return ProductCardKelola(
                      ctrl: kelolaProdukController,
                      produk: produk,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
