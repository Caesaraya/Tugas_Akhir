import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/riwayat_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';
import '../../widget/widget desktop/dashboard/app_bar_desktop.dart';
import '../../widget/widget desktop/dashboard/desktop_navigation_drawer.dart';
import '../../widget/widget desktop/dashboard/transaction_card_desktop.dart';

class KasirRiwayatDesktop extends StatelessWidget {
  final RiwayatController riwayatController = Get.put(RiwayatController());

  KasirRiwayatDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DesktopNavigationDrawer(
        currentRoute: AppRoutes.riwayatdesk,
      ),
      backgroundColor: const Color(0xFFF8F5F2), // Warna background krem bakery
      body: Column(
        children: [
          const AppBarDesktop(title: 'Riwayat Transaksi', showSearch: false),
          Expanded(
            child: Obx(() {
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
                        size: 100,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Belum ada transaksi di database",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 kolom untuk desktop
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.5, // Rasio aspek untuk card
                  ),
                  itemCount: riwayatController.transactions.length,
                  itemBuilder: (context, index) {
                    final trx = riwayatController.transactions[index];
                    return TransactionCardDesktop(transaction: trx);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
