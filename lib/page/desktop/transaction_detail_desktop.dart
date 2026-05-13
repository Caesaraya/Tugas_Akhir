import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final items = (data['items'] as List<dynamic>?) ?? [];
    final String rawMethod = data['metode_pembayaran'] ?? '-';
    final String methodLabel = rawMethod == 'cash'
        ? 'Tunai / Cash'
        : rawMethod == 'qris'
        ? 'QRIS'
        : rawMethod;

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Transaksi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ID: ${data['id'] ?? data['id_transaksi'] ?? '-'}"),
            Text("Tanggal: ${data['tanggal'] ?? '-'}"),
            Text("Metode: $methodLabel"),
            const SizedBox(height: 20),
            const Text(
              "Daftar Produk:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: items.isEmpty
                  ? const Text("Tidak ada item transaksi.")
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index] as Map<String, dynamic>;

                        // 1. Ambil Nama Produk
                        final String namaProduk =
                            item['nama_produk'] ??
                            item['name'] ??
                            item['produk'] ??
                            'Produk';

                        // 2. Ambil Harga Asli & Nilai Diskon dari Data
                        double hargaAsli =
                            double.tryParse(item['price']?.toString() ?? '0') ??
                            0;
                        double nilaiDiskonInput =
                            double.tryParse(
                              item['discount']?.toString() ?? '0',
                            ) ??
                            0;
                        double hargaSetelahDiskon;

       
                        if (nilaiDiskonInput <= 100 && nilaiDiskonInput > 0) {
                          hargaSetelahDiskon =
                              hargaAsli - (hargaAsli * nilaiDiskonInput / 100);
                        } else if (nilaiDiskonInput > 100) {
                          hargaSetelahDiskon = hargaAsli - nilaiDiskonInput;
                        } else {
                          hargaSetelahDiskon = hargaAsli;
                        }

                        final int quantity =
                            item['qty'] ?? item['quantity'] ?? 0;
                        final double subtotal =
                            double.tryParse(
                              item['subtotal']?.toString() ?? '0',
                            ) ??
                            0;
                        bool hasDiscount = nilaiDiskonInput > 0;

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            namaProduk,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Row(
                            children: [
                              Text("Qty: $quantity | "),
                              if (hasDiscount) ...[
                                // Harga asli (Kiri) dicoret merah
                                Text(
                                  currencyFormat.format(hargaAsli),
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Harga setelah diskon (Kanan)
                                Text(
                                  currencyFormat.format(hargaSetelahDiskon),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 12,
                                  ),
                                ),
                              ] else ...[
                                // Tampilan jika tidak ada diskon
                                Text(
                                  currencyFormat.format(hargaAsli),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 8),
            _buildTotalRow(
              "Total:",
              data['total_harga'],
              currencyFormat,
              isBold: true,
            ),
            _buildTotalRow("Bayar:", data['jumlah_bayar'], currencyFormat),
            _buildTotalRow(
              "Kembalian:",
              data['kembalian'],
              currencyFormat,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  // Widget bantuan untuk baris total di bawah agar rapi
  Widget _buildTotalRow(
    String label,
    dynamic value,
    NumberFormat format, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            format.format(double.tryParse(value?.toString() ?? '0') ?? 0),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
