import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/routes/routes.dart';

class TransactionCardDesktop extends StatelessWidget {
  final Map<String, dynamic> transaction;

  TransactionCardDesktop({super.key, required this.transaction});

  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.parse(transaction['tanggal']);
    String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(dt);

    final List<dynamic> items = transaction['items'] ?? [];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.toNamed(AppRoutes.transactionDetail, arguments: transaction);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          // FIX OVERFLOW
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt, color: Color(0xFFE89336)),
                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        "Nota #${transaction['id']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
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

                      ...(items.take(1).map((item) {
                        final int quantity =
                            item['qty'] ?? item['quantity'] ?? 0;

                        final String namaProduk =
                            item['name'] ??
                            item['nama_produk'] ??
                            item['product_name'] ??
                            item['produk'] ??
                            "Key Tidak Cocok";

                        final double price =
                            double.tryParse(item['price'].toString()) ?? 0;

                        final double priceAfterDiscount =
                            double.tryParse(
                              item['price_after_discount']?.toString() ?? '0',
                            ) ??
                            0;

                        double hargaFinal = priceAfterDiscount > 0
                            ? priceAfterDiscount
                            : price;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                namaProduk,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              Text(
                                "Qty: $quantity x ${currencyFormat.format(hargaFinal)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }).toList()),

                      if (items.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            "+ ${items.length - 1} item lainnya...",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE89336),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),

                const SizedBox(height: 12),

                // FIX OVERFLOW DI BAGIAN TOTAL
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
                                  transaction['total_harga'].toString(),
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
