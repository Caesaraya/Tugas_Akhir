// lib/widget/admin/uang/tabel_pengeluaran.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/admin/keuangan_controller.dart';
import '../../../widget/admin/table/table_row_cell.dart';
import '../../../widget/admin/table/table_header_cell.dart';
import '../../../widget/admin/table/table_pagination.dart';

class TabelDetailPengeluaran extends StatefulWidget {
  const TabelDetailPengeluaran({super.key});

  @override
  State<TabelDetailPengeluaran> createState() => _TabelDetailPengeluaranState();
}

class _TabelDetailPengeluaranState extends State<TabelDetailPengeluaran> {
  late int currentPage;
  static const int itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    currentPage = 1;
  }

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
            final listCategories = controller.listCategories;
            final listExpenses = controller.listExpensesBulanIni;

            if (controller.isLoading.value && listCategories.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFE65100)),
                ),
              );
            }

            if (listCategories.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: Text(
                    "Belum ada kategori pengeluaran.",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              );
            }

            // --- PROSES AGREGASI PENGELOMPOKAN KATEGORI ---
            // Gunakan listCategories sebagai daftar utama kategori
            final Map<String, double> categoryTotals = {};

            // Inisialisasi semua kategori dengan nilai 0
            for (var cat in listCategories) {
              categoryTotals[cat.name] = 0.0;
            }

            // Hitung total dari listExpensesBulanIni
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

            // Reset ke halaman 1 jika data berubah
            if (currentPage > totalPages) {
              currentPage = totalPages;
            }

            final int startIndex = (currentPage - 1) * itemsPerPage;
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
                      currentPage: currentPage,
                      totalPages: totalPages,
                      onNext: () {
                        if (currentPage < totalPages) {
                          setState(() {
                            currentPage++;
                          });
                        }
                      },
                      onPrevious: () {
                        if (currentPage > 1) {
                          setState(() {
                            currentPage--;
                          });
                        }
                      },
                      onPageSelected: (page) {
                        setState(() {
                          currentPage = page;
                        });
                      },
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
