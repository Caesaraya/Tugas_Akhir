import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/kelola_controller.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/desktop_navigation_drawer.dart';

class KasirKelolaDashboard extends StatelessWidget {
  const KasirKelolaDashboard({super.key});

  // Kolom yang lebarnya tetap (isinya pendek/pasti, tidak perlu melar).
  static const Map<String, double> _fixedWidths = {
    'no': 40,
    'diskon': 70,
    'stock': 70,
    'status': 90,
    'satuan': 70,
    'image': 60,
    'aksi': 60,
  };

  // Kolom yang ikut melebar mengisi sisa layar, dengan bobot masing-masing.
  static const Map<String, double> _flexWeights = {
    'nama': 2,
    'harga': 1,
    'hargaFinal': 1,
    'jenis': 1,
  };

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

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Hitung lebar kolom fleksibel supaya total lebar table
                  // selalu = lebar layar yang tersedia (tidak nyisa kosong).
                  const horizontalPadding = 32.0; // padding kiri+kanan
                  const columnSpacingTotal = 12.0 * 10; // 11 kolom -> 10 celah

                  final fixedTotal = _fixedWidths.values.fold(
                    0.0,
                    (a, b) => a + b,
                  );
                  final flexWeightTotal = _flexWeights.values.fold(
                    0.0,
                    (a, b) => a + b,
                  );

                  final availableForFlex =
                      (constraints.maxWidth -
                              horizontalPadding -
                              columnSpacingTotal -
                              fixedTotal)
                          .clamp(320.0, double.infinity);

                  double flexWidth(String key) {
                    final w =
                        availableForFlex *
                        (_flexWeights[key]! / flexWeightTotal);
                    return w.clamp(100.0, 600.0);
                  }

                  final namaWidth = flexWidth('nama');
                  final hargaWidth = flexWidth('harga');
                  final hargaFinalWidth = flexWidth('hargaFinal');
                  final jenisWidth = flexWidth('jenis');

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              columnSpacing: 12,
                              horizontalMargin: 12,
                              headingRowHeight: 48,
                              dataRowMinHeight: 56,
                              dataRowMaxHeight: 68,
                              columns: [
                                DataColumn(
                                  label: SizedBox(
                                    width: _fixedWidths['no'],
                                    child: const Text('No'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: namaWidth,
                                    child: const Text('Nama'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: hargaWidth,
                                    child: const Text('Harga'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: _fixedWidths['diskon'],
                                    child: const Text('Diskon'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: hargaFinalWidth,
                                    child: const Text('Harga Final'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: _fixedWidths['stock'],
                                    child: const Text('Stock'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: _fixedWidths['status'],
                                    child: const Text('Status'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: jenisWidth,
                                    child: const Text('Jenis'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: _fixedWidths['satuan'],
                                    child: const Text('Satuan'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: _fixedWidths['image'],
                                    child: const Text('Image'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: _fixedWidths['aksi'],
                                    child: const Text('Aksi'),
                                  ),
                                ),
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
                                      SizedBox(
                                        width: _fixedWidths['no'],
                                        child: Text(
                                          '$globalIndex',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: namaWidth,
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
                                      SizedBox(
                                        width: hargaWidth,
                                        child: Text(
                                          currencyFormat.format(produk.price),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),

                                    // Diskon
                                    DataCell(
                                      SizedBox(
                                        width: _fixedWidths['diskon'],
                                        child: Text(
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
                                    ),

                                    // Harga Final
                                    DataCell(
                                      SizedBox(
                                        width: hargaFinalWidth,
                                        child: Text(
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
                                    ),

                                    // Stock — merah kalau stok menipis (<10)
                                    DataCell(
                                      SizedBox(
                                        width: _fixedWidths['stock'],
                                        child: Text(
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
                                    ),

                                    // Status
                                    DataCell(
                                      SizedBox(
                                        width: _fixedWidths['status'],
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: outOfStock
                                                ? Colors.red.shade50
                                                : Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            outOfStock ? 'HABIS' : 'AKTIF',
                                            textAlign: TextAlign.center,
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
                                    ),

                                    // Jenis
                                    DataCell(
                                      SizedBox(
                                        width: jenisWidth,
                                        child: Text(
                                          produk.jenis,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),

                                    // Satuan
                                    DataCell(
                                      SizedBox(
                                        width: _fixedWidths['satuan'],
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
                                      SizedBox(
                                        width: _fixedWidths['image'],
                                        child: produk.image.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
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
                                    ),

                                    // Aksi
                                    DataCell(
                                      SizedBox(
                                        width: _fixedWidths['aksi'],
                                        child: Row(
                                          children: [
                                            // Edit
                                            IconButton(
                                              onPressed: () =>
                                                  ctrl.showEditForm(
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
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                            // Hapus
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
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
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
