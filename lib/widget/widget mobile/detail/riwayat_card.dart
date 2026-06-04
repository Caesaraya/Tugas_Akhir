import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/utils/currency.dart';

class RiwayatCard extends StatelessWidget {
  final Map<String, dynamic> trx;
  final VoidCallback onTap;

  const RiwayatCard({super.key, required this.trx, required this.onTap});

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.parse(trx['tanggal']);
    String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(dt);

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
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE89336).withValues(alpha: 0.1),
          child: const Icon(Icons.receipt, color: Color(0xFFE89336)),
        ),
        title: Text(
          "Nota ${trx['id']}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate),
            const SizedBox(height: 2),
            Text(
              "Metode: ${trx['metode_pembayaran'].toString().toUpperCase()}",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        trailing: Text(
          formatRupiah(double.parse(trx['total_harga']).toInt()),
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
