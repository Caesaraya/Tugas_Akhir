import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/keuangan_controller.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/widget/admin/mobile_admin_drawer.dart';

// Import file komponen widget baru Anda
import 'package:tugas_akhir/widget/admin/dashboard/mobile/dashboard_mobile_widget.dart';

class DashboardMobileAdminPage extends StatelessWidget {
  const DashboardMobileAdminPage({super.key});

  static const _borderColor = Color(0xFFE5E7EB);
  static const _backgroundColor = Color(0xFFF6F6F6);
  static const _subTextColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final KeuanganController controller = Get.find<KeuanganController>();
    final BahanBakuTableController bahanCtrl =
        Get.find<BahanBakuTableController>();

    return Scaffold(
      drawer: const MobileAdminDrawer(),
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0, // Material 3 behavior fix
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const DashboardLoadingWidget();
          }

          if (controller.isDashboardError.value) {
            return DashboardErrorWidget(
              controller: controller,
              subTextColor: _subTextColor,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menggunakan widget list summary yang datanya sudah selaras dengan desktop
                DashboardSummaryList(controller: controller),
                const SizedBox(height: 16),

                DashboardChartSection(
                  controller: controller,
                  borderColor: _borderColor,
                ),
                const SizedBox(height: 16),

                DashboardCriticalStockSection(
                  bahanCtrl: bahanCtrl,
                  borderColor: _borderColor,
                  subTextColor: _subTextColor,
                ),
                const SizedBox(height: 16),

                DashboardActivitySection(
                  controller: controller,
                  borderColor: _borderColor,
                  subTextColor: _subTextColor,
                  backgroundColor: _backgroundColor,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        }),
      ),
    );
  }
}
