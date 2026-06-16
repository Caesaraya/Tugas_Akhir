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
    // Format stok desimal agar rapi (.0 dibuang, angka pecahan tetap muncul)
    final String displayStok = bahanBaku.stok == bahanBaku.stok.roundToDouble()
        ? bahanBaku.stok.toInt().toString()
        : bahanBaku.stok.toString();

    // Pastikan perhitungan perkalian mengembalikan tipe double yang aman
    final double hitungTotalHarga =
        bahanBaku.totalHarga ??
        (double.parse(bahanBaku.stok.toString()) * bahanBaku.hargaSatuan);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Stok & Harga',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 15),
        BahanBakuDetailRow(label: 'Nama Bahan', value: bahanBaku.namaBahan),
        BahanBakuDetailRow(
          label: 'Merk',
          value: bahanBaku.merk.isEmpty ? '-' : bahanBaku.merk,
        ),
        BahanBakuDetailRow(
          label: 'Stok Tersedia',
          value: '$displayStok ${bahanBaku.satuan}',
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
                currency.format(hitungTotalHarga),
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
              'id',
            ).format(bahanBaku.createdAt!),
          ),
      ],
    );
  }
}
