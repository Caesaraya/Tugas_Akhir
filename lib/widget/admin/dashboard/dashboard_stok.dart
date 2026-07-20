import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:tugas_akhir/utils/app_color.dart';

class DashboardStokKritis extends StatelessWidget {
  const DashboardStokKritis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menghubungkan ke controller bahan baku asli yang terdaftar di AppBinding
    final BahanBakuTableController bahanBakuController =
        Get.find<BahanBakuTableController>();
    const backgroundColor = Color(0xFFF6F6F6);

    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Stok Bahan Kritis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppColors.black,
            //     foregroundColor: AppColors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(6),
            //     ),
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 12,
            //       vertical: 8,
            //     ),
            //   ),
            //   onPressed: () {
            //     AppRoutes.kelolabahandesk;
            //   },
            //   child: const Text('Kelola Stok', style: TextStyle(fontSize: 12)),
            // ),
          ],
        ),
        const SizedBox(height: 16),

        Expanded(
          child: Obx(() {
            // Memfilter dari list data aktif asli (yang belum dihapus/deletedAt == null)
            // Kriteria kritis: stok sudah 0 (habis) atau stok di bawah ambang batas minimal (stok < 10)
            final listKritis = bahanBakuController.originalList.where((bahan) {
              final isNotDeleted = bahan.deletedAt == null;
              final isHabis = bahan.stok == 0;
              final isMenipis = bahan.stok > 0 && bahan.stok < 10;

              return isNotDeleted && (isHabis || isMenipis);
            }).toList();

            // Tampilan jika tidak ada bahan baku yang berstatus kritis
            if (listKritis.isEmpty) {
              return const Center(
                child: Text(
                  'Semua stok bahan baku aman 👍',
                  style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(backgroundColor),
                  dataRowHeight: 48,
                  horizontalMargin: 12,
                  columnSpacing: 24,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Nama Bahan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Merk',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Sisa Stok',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Harga Satuan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                  rows: listKritis.map((bahan) {
                    String statusText = 'Menipis';
                    Color statusColor = Colors.orange;

                    // Sesuai logika pada controller: stok == 0 dianggap kritis/habis
                    if (bahan.stok == 0) {
                      statusText = 'Habis';
                      statusColor = Colors.red;
                    } else if (bahan.stok < 10) {
                      statusText = 'Menipis';
                      statusColor = Colors.amber.shade800;
                    }

                    return _buildStokRow(
                      bahan.namaBahan,
                      bahan.merk,
                      '${bahan.stok} ${bahan.satuan}',
                      currencyFormatter.format(bahan.hargaSatuan),
                      statusText,
                      statusColor,
                    );
                  }).toList(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  DataRow _buildStokRow(
    String nama,
    String merk,
    String sisa,
    String harga,
    String status,
    Color statusColor,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            nama,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ),
        DataCell(
          Text(
            merk.isEmpty ? '-' : merk,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
          ),
        ),
        DataCell(
          Text(
            sisa,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(Text(harga, style: const TextStyle(fontSize: 13))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
