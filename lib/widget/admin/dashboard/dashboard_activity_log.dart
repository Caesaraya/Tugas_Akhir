import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/keuangan_controller.dart';
import 'package:tugas_akhir/utils/app_color.dart';

class DashboardActivityLog extends StatelessWidget {
  const DashboardActivityLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final KeuanganController controller = Get.find<KeuanganController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Terbaru',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Obx(() {
            final activities = controller.dashboardActivities;

            // Empty State
            if (activities.isEmpty && !controller.isLoading.value) {
              return const Center(
                child: Text(
                  'Belum ada aktivitas terbaru',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              );
            }

            return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _buildActivityItem(
                  activity.icon, // String emoji icon
                  activity.deskripsi,
                  activity.formatWaktu(), // Menggunakan helper bawaan model
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String iconString, String text, String time) {
    const secondaryTextColor = Color(0xFF6B7280);
    const borderColor = Color(0xFFE5E7EB);
    const innerBg = Color(0xFFF6F6F6);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: innerBg,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor),
            ),
            child: Text(
              iconString, // Me-render String (emoji) dari JSON
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 12, color: secondaryTextColor),
          ),
        ],
      ),
    );
  }
}
