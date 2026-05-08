import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Nota extends StatelessWidget {
  final double total;
  final String metode;
  final double bayar;
  final double kembalian;
  final List<dynamic>? items;

  // Inisialisasi formatter agar ada titik ribuan
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  Nota({
    super.key,
    required this.total,
    required this.metode,
    required this.bayar,
    required this.kembalian,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start, // Agar judul rata kiri
      children: [
        // Judul Kecil untuk Daftar Produk
        if (items != null && items!.isNotEmpty) ...[
          const Text(
            "Rincian Produk",
            style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: items!.map((item) {
              // Menangani perbedaan nama key (name/nama_produk dan qty/jumlah)
              String nama = item['nama_produk'] ?? item['name'] ?? "Produk";
              int qty = item['jumlah'] ?? item['qty'] ?? 0;
              double harga = double.tryParse(item['harga_satuan']?.toString() ?? item['price']?.toString() ?? "0") ?? 0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "$nama x$qty",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Text(
                      currencyFormatter.format(harga * qty),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const Divider(thickness: 1, height: 30),
        ],

        // --- BAGIAN TOTAL ---
        buildRow("Total Tagihan", currencyFormatter.format(total)),
        buildRow(metode == 'cash' ? "Tunai / Cash" : metode.toUpperCase(), 
                 currencyFormatter.format(bayar)),
        
        const Divider(thickness: 1, height: 30),
        
        buildRow("Kembalian", currencyFormatter.format(kembalian), isBold: true),
        
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
        ],
      ),
    );
  }
}