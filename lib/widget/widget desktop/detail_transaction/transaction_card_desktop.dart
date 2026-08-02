import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/riwayat_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';

class TransactionCardDesktop extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final RiwayatController riwayatCtrl = Get.find<RiwayatController>();

  TransactionCardDesktop({super.key, required this.transaction});

  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    // Parsing tanggal secara aman (mencegah crash jika string tanggal kosong/null)
    DateTime? dt = DateTime.tryParse(transaction['tanggal']?.toString() ?? '');
    String formattedDate = dt != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(dt)
        : (transaction['tanggal']?.toString() ?? '-');

    final List<dynamic> items = transaction['items'] ?? [];

    // Ambil ID Transaksi (server_id/local_id) sebagai String
    final String transactionIdDisplay =
        transaction['id']?.toString() ??
        transaction['local_id']?.toString() ??
        '-';

    final String status =
        transaction['status']?.toString().toLowerCase() ?? 'synced';

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Buka detail tanpa perlu melempar Exception int.parse
          riwayatCtrl.navigateToDetail(
            transaction,
            AppRoutes.transactionDetail,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.receipt, color: Color(0xFFE89336)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Nota #$transactionIdDisplay",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Indikator status jika transaksi dibuat secara offline (pending)
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 8,
                    //     vertical: 4,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: status == 'pending'
                    //         ? Colors.orange.shade100
                    //         : Colors.green.shade100,
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Text(
                    //     status.toUpperCase(),
                    //     style: TextStyle(
                    //       fontSize: 10,
                    //       fontWeight: FontWeight.bold,
                    //       color: status == 'pending'
                    //           ? Colors.orange.shade800
                    //           : Colors.green.shade800,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(formattedDate, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  "Metode: ${(transaction['metode_pembayaran'] ?? '-').toString().toUpperCase()}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                if (items.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Item yang dibeli:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...items.take(1).map((item) {
                        final int quantity = item['qty'] is int
                            ? item['qty']
                            : (int.tryParse(item['qty']?.toString() ?? '') ??
                                  item['quantity'] ??
                                  0);

                        final String namaProduk =
                            item['name'] ??
                            item['nama_produk'] ??
                            item['product_name'] ??
                            item['produk'] ??
                            "—";

                        final double price =
                            double.tryParse(item['price']?.toString() ?? '') ??
                            0;

                        return Text(
                          "$namaProduk x$quantity (${currencyFormat.format(price)})",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                      if (items.length > 1)
                        Text(
                          "+${items.length - 1} item lainnya...",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  )
                else
                  const Text(
                    "Tap untuk lihat detail item",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Harga",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          currencyFormat.format(
                            double.tryParse(
                                  transaction['total_harga']?.toString() ?? '',
                                ) ??
                                0,
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE89336),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
