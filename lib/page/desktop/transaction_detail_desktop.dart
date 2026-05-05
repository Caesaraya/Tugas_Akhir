import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
            const Text("Item:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: items.isEmpty
                  ? const Text("Tidak ada item transaksi.")
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index] as Map<String, dynamic>;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            item['nama_produk'] ?? item['name'] ?? '-',
                          ),
                          subtitle: Text(
                            "Qty: ${item['qty'] ?? item['quantity'] ?? '-'}",
                          ),
                          trailing: Text("Rp ${item['subtotal'] ?? '0'}"),
                        );
                      },
                    ),
            ),
            const Divider(),
            Text("Total: Rp ${data['total_harga'] ?? '-'}"),
            Text("Bayar: Rp ${data['jumlah_bayar'] ?? '-'}"),
            Text("Kembalian: Rp ${data['kembalian'] ?? '-'}"),
          ],
        ),
      ),
    );
  }
}
