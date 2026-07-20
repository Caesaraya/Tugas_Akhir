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
      builder: (sheetContext) => Obx(() {
        final sortSelected = ctrl.showOutOfStockOnly.value
            ? ''
            : ctrl.sortOption.value;

        final bottomSafeArea = MediaQuery.of(sheetContext).padding.bottom;

        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 24 + bottomSafeArea),
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SortOption(
                  label: 'Default',
                  value: 'none',
                  selected: sortSelected,
                  onTap: () =>
                      ctrl.applyFilter(sort: 'none', outOfStockOnly: false),
                ),
                const SizedBox(height: 6),
                SortOption(
                  label: 'Harga Terendah ke Tertinggi',
                  value: 'low_to_high',
                  selected: sortSelected,
                  onTap: () => ctrl.applyFilter(
                    sort: 'low_to_high',
                    outOfStockOnly: false,
                  ),
                ),
                const SizedBox(height: 6),
                SortOption(
                  label: 'Harga Tertinggi ke Terendah',
                  value: 'high_to_low',
                  selected: sortSelected,
                  onTap: () => ctrl.applyFilter(
                    sort: 'high_to_low',
                    outOfStockOnly: false,
                  ),
                ),
                const SizedBox(height: 6),
                SortOption(
                  label: 'Tampilkan Hanya Stok Habis',
                  value: 'stok_habis',
                  selected: ctrl.showOutOfStockOnly.value ? 'stok_habis' : '',
                  onTap: () => ctrl.applyFilter(
                    outOfStockOnly: !ctrl.showOutOfStockOnly.value,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}