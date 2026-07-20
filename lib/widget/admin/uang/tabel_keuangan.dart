// lib/widget/admin/uang/tabel_keuangan.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/admin/table/table_row_cell.dart';
import '../../../widget/admin/table/table_header_cell.dart';
import '../../../controller/admin/keuangan_controller.dart';
import '../../../widget/admin/table/table_pagination.dart';

class TabelRekapKeuangan extends StatelessWidget {
  const TabelRekapKeuangan({super.key});

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

    // Reset halaman ke 1 jika tahun filter diubah
    ever(controller.selectedYear, (_) => currentPage.value = 1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min, // Auto-height mengikuti jumlah konten
        children: [
          // --- HEADER TABEL (JUDUL & DROPDOWN) ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Rekap Keuangan Bulanan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Obx(
                  () => Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: controller.selectedYear.value,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        items: controller.availableYears.map((int year) {
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text("Tahun $year"),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null) controller.changeYear(newValue);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- KONTEN DATA PER HALAMAN (TANPA SCROLL) ---
          Obx(() {
            if (controller.isLoading.value &&
                controller.filteredReports.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFE65100)),
                ),
              );
            }

            final allReports = controller.filteredReports;
            final int totalItems = allReports.length;
            final int totalPages = (totalItems / itemsPerPage)
                .ceil()
                .clamp(1, double.infinity)
                .toInt();

            // Validasi indeks halaman
            if (currentPage.value > totalPages) {
              currentPage.value = totalPages;
            }

            // Slice data secara presisi untuk halaman ini
            final int startIndex = (currentPage.value - 1) * itemsPerPage;
            final int endIndex = (startIndex + itemsPerPage) > totalItems
                ? totalItems
                : (startIndex + itemsPerPage);
            final pagedReports = allReports.sublist(startIndex, endIndex);

            return LayoutBuilder(
              builder: (context, constraints) {
                // Konfigurasi lebar kolom proporsional (Total 100%)
                final double totalWidth = constraints.maxWidth;
                final double wNo = totalWidth * 0.08;
                final double wBulan = totalWidth * 0.18;
                final double wPemasukan = totalWidth * 0.22;
                final double wPengeluaran = totalWidth * 0.22;
                final double wProfit = totalWidth * 0.18;
                final double wTotalTx = totalWidth * 0.12;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize:
                      MainAxisSize.min, // Menghilangkan batasan tinggi internal
                  children: [
                    // --- HEADER KOLOM ---
                    Row(
                      children: [
                        TableHeaderCell(title: 'No', width: wNo),
                        TableHeaderCell(title: 'Bulan', width: wBulan),
                        TableHeaderCell(title: 'Pemasukan', width: wPemasukan),
                        TableHeaderCell(
                          title: 'Pengeluaran',
                          width: wPengeluaran,
                        ),
                        TableHeaderCell(title: 'Profit', width: wProfit),
                        TableHeaderCell(
                          title: 'Total Transaksi',
                          width: wTotalTx,
                        ),
                      ],
                    ),

                    // --- DATA BARIS TER-PAGINASI (Maksimal Tampil 6) ---
                    ...List.generate(pagedReports.length, (index) {
                      final report = pagedReports[index];
                      final int absoluteIndex = startIndex + index;
                      final rowColor = index % 2 == 0
                          ? Colors.white
                          : const Color(0xFFF9FAFB);

                      return Row(
                        children: [
                          TableRowCell(
                            text: (absoluteIndex + 1).toString(),
                            width: wNo,
                            backgroundColor: rowColor,
                          ),
                          TableRowCell(
                            text: report.bulanNama,
                            width: wBulan,
                            backgroundColor: rowColor,
                          ),
                          TableRowCell(
                            text: _formatRupiah(report.pemasukan),
                            width: wPemasukan,
                            backgroundColor: rowColor,
                          ),
                          TableRowCell(
                            text: _formatRupiah(report.pengeluaran),
                            width: wPengeluaran,
                            backgroundColor: rowColor,
                          ),
                          TableRowCell(
                            text: '',
                            width: wProfit,
                            backgroundColor: rowColor,
                            child: Text(
                              _formatRupiah(report.profit),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: report.profit < 0
                                    ? const Color(0xFFC62828)
                                    : (report.profit > 0
                                          ? const Color(0xFF2E7D32)
                                          : Colors.black),
                              ),
                            ),
                          ),
                          TableRowCell(
                            text: report.totalTransaksi.toString(),
                            width: wTotalTx,
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
