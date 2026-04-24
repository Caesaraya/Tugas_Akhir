import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/routes/routes.dart';

class TransactionCardDesktop extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionCardDesktop({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.parse(transaction['tanggal']);
    String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(dt);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.toNamed(
            AppRoutes.sukses,
            arguments: {
              'total': transaction['total_harga'],
              'bayar': transaction['jumlah_bayar'],
              'kembalian': transaction['kembalian'],
              'metode': transaction['metode_pembayaran'],
              'isFromHistory': true,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.receipt, color: Color(0xFFE89336)),
                  const SizedBox(width: 8),
                  Text(
                    "Nota #${transaction['id']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(formattedDate, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                "Metode: ${transaction['metode_pembayaran'].toString().toUpperCase()}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "Rp ${double.parse(transaction['total_harga']).toInt()}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE89336),
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
