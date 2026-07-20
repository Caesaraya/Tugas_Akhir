import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/admin/table/table_row_cell.dart';
import '../../../widget/admin/table/table_header_cell.dart';
import '../../../controller/admin/keuangan_controller.dart';

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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.filteredReports.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFE65100)),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // MENGGUNAKAN WIDGET ASLI PROJECT (TableHeaderCell) Sesuai Desain System Berwarna Hitam
                      const Row(
                        children: [
                          TableHeaderCell(title: 'Bulan', width: 130),
                          TableHeaderCell(title: 'Pemasukan', width: 160),
                          TableHeaderCell(title: 'Pengeluaran', width: 160),
                          TableHeaderCell(title: 'Profit', width: 160),
                          TableHeaderCell(title: 'Total Transaksi', width: 120),
                        ],
                      ),
                      ...controller.filteredReports.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key;
                        final report = entry.value;
                        final rowColor = index % 2 == 0
                            ? Colors.white
                            : const Color(0xFFF9FAFB);

                        return Row(
                          children: [
                            TableRowCell(
                              text: report.bulanNama,
                              width: 130,
                              backgroundColor: rowColor,
                            ),
                            TableRowCell(
                              text: _formatRupiah(report.pemasukan),
                              width: 160,
                              backgroundColor: rowColor,
                            ),
                            TableRowCell(
                              text: _formatRupiah(report.pengeluaran),
                              width: 160,
                              backgroundColor: rowColor,
                            ),
                            TableRowCell(
                              text: '',
                              width: 160,
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
                              width: 120,
                              backgroundColor: rowColor,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
