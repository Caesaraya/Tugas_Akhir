import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/laporan_controller.dart';
import 'package:tugas_akhir/models/stock_adjustment_request.dart';
import 'package:tugas_akhir/utils/app_color.dart';
import 'package:tugas_akhir/widget/admin/custom_sidebar.dart';
import 'package:tugas_akhir/widget/admin/laporan/laporan_detail_dialog.dart';
import 'package:tugas_akhir/widget/admin/laporan/status_badge.dart';

class LaporanDeskPage extends StatelessWidget {
  const LaporanDeskPage({super.key});

  static const _backgroundColor = Color(0xFFF6F6F6);
  static const _borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final LaporanController ctrl = LaporanController.to;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSidebar(),
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value && ctrl.allReports.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.black),
                );
              }

              if (ctrl.errorMessage.value.isNotEmpty &&
                  ctrl.allReports.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(ctrl.errorMessage.value),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: ctrl.loadReports,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Laporan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Laporan produk dari kasir',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 24),

                    _buildFilterChips(ctrl),
                    const SizedBox(height: 24),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _borderColor),
                      ),
                      child: Column(
                        children: [
                          _buildTableHeader(),
                          const Divider(height: 1, color: _borderColor),
                          if (ctrl.filteredReports.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                child: Text(
                                  'Belum ada laporan',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            ...ctrl.filteredReports.map(
                              (r) => _buildTableRow(context, r),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(LaporanController ctrl) {
    return Obx(
      () => Wrap(
        spacing: 8,
        children: LaporanController.filterOptions.map((f) {
          final selected = ctrl.selectedFilter.value == f;
          return ChoiceChip(
            label: Text(f),
            selected: selected,
            onSelected: (_) => ctrl.changeFilter(f),
            selectedColor: AppColors.black,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: _borderColor),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTableHeader() {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      letterSpacing: 0.5,
    );
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('PRODUK', style: style)),
          Expanded(flex: 2, child: Text('KASIR', style: style)),
          Expanded(flex: 2, child: Text('STOK', style: style)),
          Expanded(flex: 3, child: Text('ALASAN', style: style)),
          Expanded(flex: 2, child: Text('STATUS', style: style)),
          Expanded(flex: 1, child: Text('AKSI', style: style)),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, StockAdjustmentRequest r) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _borderColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              r.productName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 2, child: Text(r.userName)),
          Expanded(flex: 2, child: Text('${r.oldStock} → ${r.newStock}')),
          Expanded(
            flex: 3,
            child: Text(r.reason, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          Expanded(flex: 2, child: LaporanStatusBadge(status: r.status)),
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => LaporanDetailDialog(report: r),
                );
              },
              child: const Text('Detail'),
            ),
          ),
        ],
      ),
    );
  }
}
