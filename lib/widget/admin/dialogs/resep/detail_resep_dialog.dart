import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/resep.dart';
import 'package:tugas_akhir/utils/currency.dart';
import '../custom_form_fields.dart';

class DetailResepDialog extends StatelessWidget {
  final Resep resep;
  const DetailResepDialog({super.key, required this.resep});

  static const Color _primaryColor = Color(0xFFE65100);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 850,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialogCommonTitle(
              title: 'Detail Resep: ${resep.namaResep}',
              icon: Icons.assignment_rounded,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(thickness: 1),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(),
                    const SizedBox(height: 20),
                    const Text(
                      '📋 Komposisi Bahan Baku Terdaftar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildBahanTable(),
                  ],
                ),
              ),
            ),

            const Divider(height: 30, thickness: 1),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black87, width: 1.5),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 20,
                  ),
                  label: const Text(
                    'Selesai',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    // Menghitung total HPP secara dinamis dari model resep.bahan Anda
    double hitungTotalHpp = 0.0;
    if (resep.bahan != null) {
      for (var b in resep.bahan!) {
        hitungTotalHpp += b.totalHargaBahan!;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi / Petunjuk Resep:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            resep.deskripsi.isNotEmpty
                ? resep.deskripsi
                : "Tidak ada deskripsi cara pembuatan.",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text(
                'Estimasi HPP Resep: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              Text(
                formatRupiah(hitungTotalHpp),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBahanTable() {
    // Disesuaikan ke resep.bahan berdasarkan property model resep.dart Anda
    if (resep.bahan == null || resep.bahan!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Resep ini belum memiliki daftar bahan baku.',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.amber.shade50),
            children: const [
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Nama Bahan Baku',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Jumlah',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Harga Satuan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Subtotal HPP',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          // Property diubah menyesuaikan model DetailResep Anda (namaBahan, satuan, hargaSatuan, totalHargaBahan)
          ...resep.bahan!.map((item) {
            return TableRow(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    item.namaBahan ?? 'Bahan Tidak Diketahui',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('${item.jumlahBahan} ${item.satuan ?? ''}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(formatRupiah(item.hargaSatuan ?? 0)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    formatRupiah(item.totalHargaBahan as num),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
