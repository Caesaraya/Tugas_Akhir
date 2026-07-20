// lib/widget/admin/uang/tabel_pengeluaran.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/admin/keuangan_controller.dart';
import '../../../widget/admin/table/table_row_cell.dart';
import '../../../widget/admin/table/table_header_cell.dart';
import '../../../widget/admin/table/table_pagination.dart';

class TabelDetailPengeluaran extends StatelessWidget {
  const TabelDetailPengeluaran({super.key});

  String _formatRupiah(double value) {
    String result = value
        .abs()
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    return value < 0 ? '-Rp $result' : 'Rp $result';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KeuanganController>();

    // State reaktif pagination lokal (6 item per halaman)
    final RxInt currentPage = 1.obs;
    const int itemsPerPage = 6;

    // Reset halaman jika sumber data bulan diperbarui
    ever(controller.listExpensesBulanIni, (_) => currentPage.value = 1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min, // Auto-height sesuai jumlah kategori
        children: [
          // --- HEADER JUDUL ---
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Rekap Pengeluaran per Kategori",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          Obx(() {
            final listExpenses = controller.listExpensesBulanIni;

            if (controller.isLoading.value && listExpenses.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFE65100)),
                ),
              );
            }

            if (listExpenses.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: Text(
                    "Belum ada data pengeluaran.",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              );
            }

            // --- PROSES AGREGASI PENGELOMPOKAN KATEGORI ---
            final Map<String, double> categoryTotals = {};
            for (var exp in listExpenses) {
              final catName = exp.categoryName;
              categoryTotals[catName] =
                  (categoryTotals[catName] ?? 0) + exp.nominal;
            }

            // Urutkan nominal dari terbesar ke terkecil
            final sortedCategories = categoryTotals.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            // --- HITUNG LOGIKA PAGINATION ---
            final int totalItems = sortedCategories.length;
            final int totalPages = (totalItems / itemsPerPage)
                .ceil()
                .clamp(1, double.infinity)
                .toInt();

            if (currentPage.value > totalPages) {
              currentPage.value = totalPages;
            }

            final int startIndex = (currentPage.value - 1) * itemsPerPage;
            final int endIndex = (startIndex + itemsPerPage) > totalItems
                ? totalItems
                : (startIndex + itemsPerPage);
            final pagedCategories = sortedCategories.sublist(
              startIndex,
              endIndex,
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                final double totalWidth = constraints.maxWidth;
                final double wNo = totalWidth * 0.10;
                final double wKategori = totalWidth * 0.50;
                final double wNominal = totalWidth * 0.40;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize:
                      MainAxisSize.min, // Tanpa batasan tinggi / scroll
                  children: [
                    // --- HEADER KOLOM ---
                    Row(
                      children: [
                        TableHeaderCell(title: 'No', width: wNo),
                        TableHeaderCell(title: 'Kategori', width: wKategori),
                        TableHeaderCell(
                          title: 'Total Nominal',
                          width: wNominal,
                        ),
                      ],
                    ),

                    // --- DATA REKAP KATEGORI (Maksimal Tampil 6) ---
                    ...List.generate(pagedCategories.length, (index) {
                      final entry = pagedCategories[index];
                      final int absoluteIndex = startIndex + index;
                      final rowColor = index % 2 == 1
                          ? const Color(0xFFF8F9FA)
                          : Colors.white;

                      return Row(
                        children: [
                          TableRowCell(
                            text: (absoluteIndex + 1).toString(),
                            width: wNo,
                            backgroundColor: rowColor,
                          ),
                          TableRowCell(
                            text: entry.key,
                            width: wKategori,
                            backgroundColor: rowColor,
                          ),
                          TableRowCell(
                            text: _formatRupiah(entry.value),
                            width: wNominal,
                            backgroundColor: rowColor,
                          ),
                        ],
                      );
                    }),

                    // --- PAGINATION KONTROL ---
                    TablePagination(
                      currentPage: currentPage.value,
                      totalPages: totalPages,
                      onNext: () => currentPage.value++,
                      onPrevious: () => currentPage.value--,
                      onPageSelected: (page) => currentPage.value = page,
                    ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
