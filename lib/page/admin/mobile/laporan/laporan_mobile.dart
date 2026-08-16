import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/laporan_controller.dart';
import 'package:tugas_akhir/models/stock_adjustment_request.dart';
import 'package:tugas_akhir/widget/admin/laporan/laporan_detail_dialog.dart';
import 'package:tugas_akhir/widget/admin/laporan/status_badge.dart';
import 'package:tugas_akhir/widget/admin/mobile_admin_drawer.dart';

class LaporanMobilePage extends StatelessWidget {
  const LaporanMobilePage({super.key});

  static const _backgroundColor = Color(0xFFF6F6F6);
  static const _borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final LaporanController ctrl = LaporanController.to;

    return Scaffold(
      drawer: const MobileAdminDrawer(),
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Laporan',
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
          if (ctrl.isLoading.value && ctrl.allReports.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          return RefreshIndicator(
            onRefresh: ctrl.loadReports,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildFilterChips(ctrl),
                const SizedBox(height: 16),
                if (ctrl.filteredReports.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 48),
                    child: Center(
                      child: Text(
                        'Belum ada laporan',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...ctrl.filteredReports.map((r) => _buildCard(context, r)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFilterChips(LaporanController ctrl) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: LaporanController.filterOptions.map((f) {
          final selected = ctrl.selectedFilter.value == f;
          return ChoiceChip(
            label: Text(f),
            selected: selected,
            onSelected: (_) => ctrl.changeFilter(f),
            selectedColor: Colors.black,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 13,
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

  Widget _buildCard(BuildContext context, StockAdjustmentRequest r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  r.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              LaporanStatusBadge(status: r.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            r.userName,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Text(
            'Stok: ${r.oldStock} → ${r.newStock}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Alasan: ${r.reason}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => LaporanDetailDialog(report: r),
                );
              },
              child: const Text('Lihat Detail >'),
            ),
          ),
        ],
      ),
    );
  }
}
