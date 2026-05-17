import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/kelola_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/kasir_mobile_drawer.dart';

class KelolaProdukPage extends StatelessWidget {
  final KelolaProdukController controller = Get.find<KelolaProdukController>();
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const KasirMobileDrawer(),
      backgroundColor: const Color(0xFFF8F5F2),
      appBar: AppBar(
        title: const Text(
          "Kelola Produk",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE89336),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => controller.fetchData(),
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: "Cari Produk...",
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
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFE89336)),
                );
              }
              if (controller.filteredProducts.isEmpty) {
                return const Center(
                  child: Text(
                    "Produk tidak ditemukan",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
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
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: produk.image.isNotEmpty
                                ? Image.network(
                                    produk.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  )
                                : const Icon(
                                    Icons.image,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                        title: Text(
                          produk.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((produk.discount ?? 0) > 0) ...[
                                Text(
                                  currencyFormatter.format(produk.price),
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  currencyFormatter.format(
                                    produk.priceAfterDiscount,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  currencyFormatter.format(produk.price),
                                  style: const TextStyle(
                                    color: Color(0xFFE89336),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 2),
                              Text(
                                "Stok: ${produk.stock} ${produk.satuan} | ${produk.jenis.toUpperCase()}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () =>
                              controller.showEditForm(context, produk),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Edit"),
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
