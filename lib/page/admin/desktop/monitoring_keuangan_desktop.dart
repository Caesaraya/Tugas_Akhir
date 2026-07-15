import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/widget/admin/custom_sidebar.dart';
import 'package:tugas_akhir/widget/admin/uang/card_keuangan.dart';
import '../../../controller/admin/keuangan_controller.dart';

class MonitoringKeuanganPage extends StatelessWidget {
  MonitoringKeuanganPage({super.key});

  final controller = Get.put(KeuanganController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // Background abu-abu sangat muda khas dashboard
      body: Row(
        children: [
          AdminSidebar(),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Halaman
                const Padding(
                  padding: EdgeInsets.only(left: 24, top: 24),
                  child: Text(
                    "Monitoring Keuangan",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 24, bottom: 24),
                  child: Text(
                    "Ringkasan pemasukan dan performa bisnis bulan ini",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                // Baris Kartu Summary
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final data = controller.keuangan.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: CardKeuangan(
                            judul: 'Pemasukan',
                            nominal: data.pemasukan,
                            subJudul: 'Total omset bulan ini',
                            icon: Icons.account_balance_wallet_outlined,
                            warnaAksen: Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: CardKeuangan(
                            judul: 'Pengeluaran',
                            nominal: data.pengeluaran,
                            subJudul: 'Estimasi pengeluaran',
                            icon: Icons.shopping_cart_outlined,
                            warnaAksen: Colors.orange,
                          ),
                        ),
                        Expanded(
                          child: CardKeuangan(
                            judul: 'Profit Bersih',
                            nominal: data.profit,
                            subJudul: 'Keuntungan setelah dipotong',
                            icon: Icons.trending_up,
                            warnaAksen: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
