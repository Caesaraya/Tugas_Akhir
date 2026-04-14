import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/riwayat_controller.dart';

import 'package:tugas_akhir/page/mobile/sukses_mobile_page.dart';

class RiwayatMobile extends StatelessWidget {
  final RiwayatController riwayatController = Get.put(RiwayatController());
  RiwayatMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2), // Warna background krem bakery
      appBar: AppBar(
        title: const Text(
          "Riwayat Transaksi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // Tombol refresh untuk menarik data terbaru dari API
        actions: [
          IconButton(
            onPressed: () => riwayatController.fetchHistory(),
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
        ],
      ),
      body: Obx(() {
        // Tampilkan loading spinner saat data sedang diambil dari API
        if (riwayatController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Tampilkan pesan jika data kosong
        if (riwayatController.transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Belum ada transaksi di database",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        // List Riwayat
      // ... (bagian atas tetap sama)

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: riwayatController.transactions.length,
          itemBuilder: (context, index) {
            final trx = riwayatController.transactions[index];

            DateTime dt = DateTime.parse(trx['tanggal']);
            String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(dt);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                // --- TAMBAHKAN ONTAP DI SINI ---
                onTap: () {
                  Get.to(
                    () => SuksesMobilePage(), 
                    arguments: {
                      'total': trx['total_harga'],
                      'bayar': trx['jumlah_bayar'],
                      'kembalian': trx['kembalian'],
                      'metode': trx['metode_pembayaran'],
                      'isFromHistory': true, // Penanda untuk membedakan transaksi baru vs riwayat
                    },
                  );
                },
                // ------------------------------
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE89336).withOpacity(0.1),
                  child: const Icon(Icons.receipt, color: Color(0xFFE89336)),
                ),
                title: Text(
                  "Nota #${trx['id']}",
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
                  "Rp ${double.parse(trx['total_harga']).toInt()}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE89336),
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        );

// ... (sisanya tetap sama)
      }),
    );
  }
}
