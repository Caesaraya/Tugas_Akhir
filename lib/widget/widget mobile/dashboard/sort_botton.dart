import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard/option.dart';

class SortBottomSheet {
  static void show(BuildContext context) {
    final ctrl = Get.find<DashboardController>();

    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Obx(
        () => Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Urutkan Berdasarkan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SortOption(
                label: 'Default',
                value: 'none',
                selected: ctrl.sortOption.value,
                onTap: () => ctrl.applyFilter(sort: 'none'),
              ),
              const SizedBox(height: 6),
              SortOption(
                label: 'Harga Terendah ke Tertinggi',
                value: 'low_to_high',
                selected: ctrl.sortOption.value,
                onTap: () => ctrl.applyFilter(sort: 'low_to_high'),
              ),
              const SizedBox(height: 6),
              SortOption(
                label: 'Harga Tertinggi ke Terendah',
                value: 'high_to_low',
                selected: ctrl.sortOption.value,
                onTap: () => ctrl.applyFilter(sort: 'high_to_low'),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE89336),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Terapkan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}