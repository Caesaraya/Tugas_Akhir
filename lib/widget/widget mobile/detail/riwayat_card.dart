import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/utils/currency.dart';

class RiwayatCard extends StatelessWidget {
  final Map<String, dynamic> trx;
  final VoidCallback onTap;

  const RiwayatCard({super.key, required this.trx, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // ================================
    // TANGGAL
    // ================================
    DateTime dt;

    try {
      final tanggal = trx['tanggal'];

      if (tanggal is DateTime) {
        dt = tanggal;
      } else {
        dt = DateTime.parse(tanggal.toString());
      }
    } catch (_) {
      dt = DateTime.now();
    }

    final String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(dt);

    // ================================
    // ID TRANSAKSI
    // ================================
    final String transactionId = trx['id']?.toString() ?? '-';

    // ================================
    // METODE PEMBAYARAN
    // ================================
    final String paymentMethod =
        trx['metode_pembayaran']?.toString().toUpperCase() ?? '-';

    // ================================
    // TOTAL HARGA
    // ================================
    //
    // Jangan menggunakan:
    // double.parse(trx['total_harga'])
    //
    // karena total_harga bisa sudah berupa
    // double / int / String.
    //
    double totalHarga = 0.0;

    final dynamic rawTotal = trx['total_harga'];

    if (rawTotal is num) {
      // Jika API mengirim double atau int
      totalHarga = rawTotal.toDouble();
    } else {
      // Jika API mengirim String
      totalHarga = double.tryParse(rawTotal?.toString() ?? '') ?? 0.0;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,

        // ================================
        // ICON
        // ================================
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE89336).withValues(alpha: 0.1),
          child: const Icon(Icons.receipt, color: Color(0xFFE89336)),
        ),

        // ================================
        // JUDUL
        // ================================
        title: Text(
          'Nota $transactionId',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        // ================================
        // DETAIL
        // ================================
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate),

            const SizedBox(height: 2),

            Text(
              'Metode: $paymentMethod',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),

        // ================================
        // TOTAL
        // ================================
        trailing: Text(
          formatRupiah(totalHarga.toInt()),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFE89336),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
