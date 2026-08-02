import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/kelola_controller.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/desktop_navigation_drawer.dart';

class KasirKelolaDashboard extends StatelessWidget {
  const KasirKelolaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<KelolaProdukController>();
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      drawer: const DesktopNavigationDrawer(),
      appBar: AppBar(
        title: const Text(
          'Kelola Produk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE89336),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => ctrl.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: 'Search',
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
              final paginatedList = ctrl.paginatedProducts;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              const Color(0xFFE89336),
                            ),
                            headingTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            dataRowColor: WidgetStateProperty.resolveWith(
                              (states) => Colors.white,
                            ),
                            border: TableBorder.all(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            columnSpacing: 20,
                            columns: const [
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Nama')),
                              DataColumn(label: Text('Harga')),
                              DataColumn(label: Text('Diskon')),
                              DataColumn(label: Text('Harga Final')),
                              DataColumn(label: Text('Stock')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Jenis')),
                              DataColumn(label: Text('Satuan')),
                              DataColumn(label: Text('Image')),
                              DataColumn(label: Text('Aksi')),
                            ],
                            rows: List.generate(paginatedList.length, (i) {
                              final produk = paginatedList[i];
                              final bool outOfStock = produk.stock <= 0;
                              final bool lowStock = produk.stock < 10;

                              // Menghitung nomor urut kontinu lintas halaman
                              final int globalIndex =
                                  ((ctrl.currentPage.value - 1) *
                                      KelolaProdukController.pageSize) +
                                  i +
                                  1;

                              return DataRow(
                                cells: [
                                  // No
                                  DataCell(
                                    Text(
                                      '$globalIndex',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 180,
                                      child: Text(
                                        produk.name,
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Harga
                                  DataCell(
                                    Text(
                                      currencyFormat.format(produk.price),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),

                                  // Diskon
                                  DataCell(
                                    Text(
                                      produk.discount > 0
                                          ? '${produk.discount}%'
                                          : '-',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: produk.discount > 0
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),

                                  // Harga Final
                                  DataCell(
                                    Text(
                                      currencyFormat.format(
                                        produk.priceAfterDiscount,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFE89336),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  // Stock — merah kalau stok menipis (<10)
                                  DataCell(
                                    Text(
                                      '${produk.stock}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: lowStock
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),

                                  // Status
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: outOfStock
                                            ? Colors.red.shade50
                                            : Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        outOfStock ? 'HABIS' : 'AKTIF',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: outOfStock
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Jenis
                                  DataCell(
                                    Text(
                                      produk.jenis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),

                                  // Satuan
                                  DataCell(
                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        produk.satuan,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),

                                  // Image
                                  DataCell(
                                    produk.image.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            child: Image.network(
                                              produk.image,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                  ),

                                  // Aksi
                                  DataCell(
                                    Row(
                                      children: [
                                        // Edit
                                        IconButton(
                                          onPressed: () => ctrl.showEditForm(
                                            context,
                                            produk,
                                          ),
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          tooltip: 'Edit',
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        const SizedBox(width: 8),
                                        // Hapus
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: ctrl.currentPage.value > 1
                                  ? () => ctrl.prevPage()
                                  : null,
                            ),
                            Text(
                              'Halaman ${ctrl.currentPage.value} dari ${ctrl.totalPages}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed:
                                  ctrl.currentPage.value < ctrl.totalPages
                                  ? () => ctrl.nextPage()
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
