import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/models/bahan_baku.dart';
import 'package:tugas_akhir/widget/admin/bahan/mobile/bahan_baku_detail_action_bar.dart';
import 'package:tugas_akhir/widget/admin/bahan/mobile/bahan_baku_detail_header.dart';
import 'package:tugas_akhir/widget/admin/bahan/mobile/bahan_baku_detail_info.dart';

class BahanBakuDetailPage extends StatelessWidget {
  final BahanBaku bahanBaku;

  const BahanBakuDetailPage({super.key, required this.bahanBaku});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final controller = Get.find<BahanBakuTableController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Detail Bahan Baku',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        // Cari data terbaru dari state controller agar real-time saat soft-delete / restore dilakukan
        final currentBahan = controller.originalList.firstWhere(
          (element) => element.id == bahanBaku.id,
          orElse: () => bahanBaku,
        );

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BahanBakuDetailHeader(bahanBaku: currentBahan),
                    BahanBakuDetailInfo(
                      bahanBaku: currentBahan,
                      currency: currency,
                    ),
                  ],
                ),
              ),
            ),
            BahanBakuDetailActionBar(
              controller: controller,
              bahanBaku: currentBahan,
            ),
          ],
        );
      }),
    );
  }
}
