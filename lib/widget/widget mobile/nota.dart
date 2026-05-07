import 'package:flutter/material.dart';

class Nota extends StatelessWidget {
  final double total;
  final String metode;
  final double bayar;
  final double kembalian;
  final List<dynamic>? items; 

  const Nota({
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
      children: [
        const Text(
          "RUMAH LEZAA",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Text("Bakery & Cake Custom"),
        const Divider(thickness: 1, height: 30),

        // --- BAGIAN DAFTAR PRODUK ---
        if (items != null)
          Column(
            children: items!.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nama Produk & Qty
                    Expanded(
                      child: Text(
                        "${item['nama_produk']} x${item['jumlah']}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    // Harga Total per Item (Qty * Harga)
                    Text(
                      "Rp ${(double.parse(item['harga_satuan']) * item['jumlah']).toInt()}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        
        const Divider(thickness: 1, height: 30),
        // --- SELESAI DAFTAR PRODUK ---
   
        buildRow("Total Tagihan", "Rp ${total.toInt()}"),
        buildRow(metode, "Rp ${bayar.toInt()}"),
        
        const Divider(thickness: 1, height: 30),
        
        buildRow("Kembalian", "Rp ${kembalian.toInt()}", isBold: true),
        
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
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}