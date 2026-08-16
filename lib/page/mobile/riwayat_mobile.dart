import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tugas_akhir/controller/riwayat_controller.dart';
import 'package:tugas_akhir/page/mobile/drawer_mobile.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:tugas_akhir/widget/widget mobile/detail/riwayat_card.dart';
import 'package:tugas_akhir/widget/widget mobile/detail/riwayat_empety.dart';

class RiwayatMobile extends StatelessWidget {
  RiwayatMobile({super.key});

  final RiwayatController riwayatController = Get.find<RiwayatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const KasirMobileDrawer(),
      backgroundColor: const Color(0xFFF8F5F2),

      appBar: AppBar(
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE89336),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Obx(() {
        // Loading
        if (riwayatController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Tidak ada transaksi
        if (riwayatController.transactions.isEmpty) {
          return const RiwayatEmpty();
        }

        // Daftar transaksi
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: riwayatController.transactions.length,
          itemBuilder: (context, index) {
            final trx = riwayatController.transactions[index];

            return RiwayatCard(
              trx: trx,
              onTap: () {
                riwayatController.navigateToDetail(
                  trx,
                  AppRoutes.transactionDetailMobile,
                );
              },
            );
          },
        );
      }),
    );
  }
}
