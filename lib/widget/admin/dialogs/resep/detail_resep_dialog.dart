import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/resep.dart';
import 'package:tugas_akhir/utils/currency.dart';

class DetailResepDialog extends StatelessWidget {
  final Resep resep;

  const DetailResepDialog({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width:
            850, // Lebar optimal untuk tampilan desktop agar tabel tidak sesak
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Dialog
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Resep: ${resep.namaResep}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "ID Resep: #${resep.id}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(height: 30),

            // Konten dengan Scroll Vertikal
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informasi Deskripsi
                    const Text(
                      'Deskripsi Resep:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        resep.deskripsi.isEmpty ? "-" : resep.deskripsi,
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Judul Tabel Bahan
                    Row(
                      children: [
                        const Icon(
                          Icons.flatware,
                          size: 20,
                          color: Colors.cyan,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Komposisi Bahan Baku',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${resep.bahan?.length ?? 0} Jenis Bahan",
                          style: TextStyle(
                            color: Colors.cyan[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Tabel Bahan Baku
                    if (resep.bahan == null || resep.bahan!.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text(
                            'Tidak ada rincian bahan untuk resep ini.',
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: DataTable(
                            columnSpacing: 24,
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Nama Bahan',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Merk',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Jumlah',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Satuan',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Estimasi Biaya',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: resep.bahan!.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(item.namaBahan ?? '-')),
                                  DataCell(Text(item.merk ?? '-')),
                                  DataCell(Text(item.jumlahBahan.toString())),
                                  DataCell(Text(item.satuan ?? '-')),
                                  DataCell(
                                    Text(
                                      formatRupiah(item.totalHargaBahan ?? 0),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            const Divider(height: 30),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Selesai'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
