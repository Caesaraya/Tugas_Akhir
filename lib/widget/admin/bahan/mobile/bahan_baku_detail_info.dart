import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/models/bahan_baku.dart';
import 'package:tugas_akhir/widget/admin/bahan/mobile/bahan_baku_detail_row.dart';

class BahanBakuDetailInfo extends StatelessWidget {
  final BahanBaku bahanBaku;
  final NumberFormat currency;

  const BahanBakuDetailInfo({
    super.key,
    required this.bahanBaku,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Stok & Harga',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 15),
        BahanBakuDetailRow(label: 'Nama Bahan', value: bahanBaku.namaBahan),
        BahanBakuDetailRow(label: 'Merk', value: bahanBaku.merk),
        BahanBakuDetailRow(
          label: 'Stok Tersedia',
          value: '${bahanBaku.stok} ${bahanBaku.satuan}',
        ),
        BahanBakuDetailRow(label: 'Satuan', value: bahanBaku.satuan),
        BahanBakuDetailRow(
          label: 'Harga per ${bahanBaku.satuan}',
          value: currency.format(bahanBaku.hargaSatuan),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF5D4037).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF5D4037).withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Nilai Stok',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                currency.format(
                  bahanBaku.totalHarga ??
                      (bahanBaku.stok * bahanBaku.hargaSatuan),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
            ],
          ),
        ),
        if (bahanBaku.createdAt != null)
          BahanBakuDetailRow(
            label: 'Terakhir Diupdate',
            value: DateFormat(
              'dd MMM yyyy, HH:mm',
            ).format(bahanBaku.createdAt!),
          ),
      ],
    );
  }
}
