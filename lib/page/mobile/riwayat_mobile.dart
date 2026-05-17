import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/page/mobile/drawer_mobile.dart';
import 'package:tugas_akhir/utils/currency.dart';
import 'package:tugas_akhir/controller/riwayat_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';

class RiwayatMobile extends StatelessWidget {
  final RiwayatController riwayatController = Get.find<RiwayatController>();
  RiwayatMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const KasirMobileDrawer(),
      backgroundColor: const Color(0xFFF8F5F2),
      appBar: AppBar(
        title: const Text(
          "Riwayat Transaksi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => riwayatController.fetchHistory(),
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
        ],
      ),
      body: Obx(() {
        if (riwayatController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
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
                onTap: () {
                  Get.toNamed(
                    AppRoutes.transactionDetailMobile,
                    arguments: {
                      'id': trx['id'],
                      'tanggal': trx['tanggal'],
                      'total_harga': trx['total_harga'],
                      'jumlah_bayar': trx['jumlah_bayar'],
                      'kembalian': trx['kembalian'],
                      'metode_pembayaran': trx['metode_pembayaran'],
                      'items': trx['items'], // PENTING
                    },
                  );
                },
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
                  formatRupiah(double.parse(trx['total_harga']).toInt()),
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
      }),
    );
  }
}
