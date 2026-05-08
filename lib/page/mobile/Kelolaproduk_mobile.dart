import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/mobile/kelola_controller.dart';

class KelolaProdukPage extends StatelessWidget {
  // Inisialisasi Controller khusus KelolaProduk
  final KelolaProdukController controller = Get.put(KelolaProdukController());
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      appBar: AppBar(
        title: const Text("Kelola Produk", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFE89336),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.refreshData(),
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: "Cari Produk...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), 
                  borderSide: BorderSide.none
                ),
              ),
            ),
          ),

          // List Produk Reaktif
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFE89336)));
              }

              if (controller.filteredProducts.isEmpty) {
                return const Center(child: Text("Produk tidak ditemukan"));
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchData(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final produk = controller.filteredProducts[index];
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: produk.image != null && produk.image!.isNotEmpty
                              ? Image.network(produk.image!, width: 60, height: 60, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
                              : const Icon(Icons.image, size: 60),
                        ),
                        title: Text(produk.name ?? "", 
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(currencyFormatter.format(produk.price ?? 0)),
                            Text("Stok: ${produk.stock}", style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {controller.showEditForm(context, produk);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          ),
                          child: const Text("Edit", style: TextStyle(color: Colors.white)),
                        ),
                      ),
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