import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/resep.dart';
import 'package:tugas_akhir/utils/currency.dart';
import '../custom_form_fields.dart';

class DetailResepDialog extends StatelessWidget {
  final Resep resep;
  const DetailResepDialog({super.key, required this.resep});

  static const Color _themeColor = Color(0xFF1E1E1E);

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
              child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(),
                    const SizedBox(height: 20),
                    const Text(
                      '📋 Komposisi Bahan Terpakai:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _themeColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildBahanTable(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _themeColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                onPressed: () => Get.back(),
                child: const Text(
                  'Tutup Detail',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resep.deskripsi.isNotEmpty
                ? resep.deskripsi
                : 'Tidak ada deskripsi resep.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildBadgedInfo(
                Icons.flatware_rounded,
                'Total Varian Bahan: ${resep.bahan?.length ?? 0}',
              ),
              const SizedBox(width: 24),
              _buildBadgedInfo(
                Icons.monetization_on_rounded,
                'Estimasi Modal Resep: ${formatRupiah(resep.bahan?.fold<double>(0.0, (sum, item) => sum + (item.totalHargaBahan ?? 0.0)) ?? 0.0)}',
                textColor: Colors.green.shade800,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgedInfo(IconData icon, String text, {Color? textColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: _themeColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildBahanTable() {
    if (resep.bahan == null || resep.bahan!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: const Text('Resep ini tidak memiliki komposisi bahan baku.'),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2.5),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(1.5),
          3: FlexColumnWidth(1.5),
        },
        children: [
          const TableRow(
            decoration: BoxDecoration(color: _themeColor),
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Nama Bahan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Takaran Resep',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Harga Satuan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Sub Total',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          ...resep.bahan!.map((item) {
            return TableRow(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
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
                // KODE BARU (SUDAH DIPERBAIKI)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    formatRupiah(
                      item.totalHargaBahan ?? 0.0,
                    ), // <--- Menggunakan operator ??
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
