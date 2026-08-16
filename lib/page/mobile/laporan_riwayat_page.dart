import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tugas_akhir/controller/lapor_produk_controller.dart';
import 'package:tugas_akhir/models/stock_adjustment_request.dart';

class LaporanRiwayatPage extends StatelessWidget {
  const LaporanRiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LaporProdukController ctrl = Get.isRegistered<LaporProdukController>()
        ? Get.find<LaporProdukController>()
        : Get.put(LaporProdukController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),

      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFFE89336),
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'Riwayat Laporan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        iconTheme: const IconThemeData(color: Colors.white),

        actions: [
          Obx(
            () => IconButton(
              tooltip: 'Refresh',
              onPressed: ctrl.isLoadingHistory.value
                  ? null
                  : () => ctrl.refreshHistory(),
              icon: ctrl.isLoadingHistory.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.refresh, color: Colors.white),
            ),
          ),
        ],
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: Obx(() {
        if (ctrl.isLoadingHistory.value &&
            ctrl.stockAdjustmentRequests.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE89336)),
          );
        }

        final list = ctrl.stockAdjustmentRequests;

        if (list.isEmpty) {
          return RefreshIndicator(
            color: const Color(0xFFE89336),
            onRefresh: ctrl.refreshHistory,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 180),

                Icon(Icons.assignment_outlined, size: 65, color: Colors.grey),

                SizedBox(height: 15),

                Center(
                  child: Text(
                    'Belum ada laporan',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),

                SizedBox(height: 8),

                Center(
                  child: Text(
                    'Laporan produk yang kamu buat akan muncul di sini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFE89336),
          onRefresh: ctrl.refreshHistory,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final laporan = list[index];

              return _LaporanHistoryCard(laporan: laporan, ctrl: ctrl);
            },
          ),
        );
      }),
    );
  }
}

// ==================================================================
// CARD RIWAYAT LAPORAN
// ==================================================================

class _LaporanHistoryCard extends StatelessWidget {
  final StockAdjustmentRequest laporan;
  final LaporProdukController ctrl;

  const _LaporanHistoryCard({required this.laporan, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final status = laporan.status.toLowerCase();

    final statusColor = ctrl.getStatusColor(laporan.status);

    final statusIcon = ctrl.getStatusIcon(laporan.status);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showDetail(context),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====================================================
            // PRODUK + STATUS
            // ====================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    laporan.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 13, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        ctrl.getStatusText(laporan.status),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ====================================================
            // STOCK
            // ====================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 18,
                    color: Color(0xFFE89336),
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    'Stock',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  const Spacer(),

                  Text(
                    '${laporan.oldStock}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 15,
                      color: Colors.grey,
                    ),
                  ),

                  Text(
                    '${laporan.newStock}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: status == 'approved'
                          ? Colors.green
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ====================================================
            // ALASAN
            // ====================================================
            Text(
              laporan.reason,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),

            // ====================================================
            // TANGGAL
            // ====================================================
            if (laporan.createdAt != null) ...[
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),

                  const SizedBox(width: 5),

                  Text(
                    '${laporan.createdAt!.toLocal().day.toString().padLeft(2, '0')}/'
                    '${laporan.createdAt!.toLocal().month.toString().padLeft(2, '0')}/'
                    '${laporan.createdAt!.toLocal().year} '
                    '${laporan.createdAt!.toLocal().hour.toString().padLeft(2, '0')}:'
                    '${laporan.createdAt!.toLocal().minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ],

            // ====================================================
            // STATUS INFORMATION
            // ====================================================
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.07),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(statusIcon, color: statusColor, size: 16),

                  const SizedBox(width: 7),

                  Expanded(
                    child: Text(
                      ctrl.getStockChangeText(laporan),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ====================================================
            // ADMIN
            // ====================================================
            if (laporan.approvedByName != null &&
                laporan.approvedByName!.isNotEmpty &&
                status != 'pending') ...[
              const SizedBox(height: 7),

              Text(
                'Diproses oleh: ${laporan.approvedByName}',
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =================================================================
  // DETAIL
  // =================================================================

  void _showDetail(BuildContext context) {
    final statusColor = ctrl.getStatusColor(laporan.status);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          title: const Text(
            'Detail Laporan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _detailRow('Produk', laporan.productName),

                _detailRow(
                  'Status',
                  ctrl.getStatusText(laporan.status),
                  valueColor: statusColor,
                ),

                _detailRow('Stock Lama', '${laporan.oldStock}'),

                _detailRow('Stock Baru', '${laporan.newStock}'),

                _detailRow('Pelapor', laporan.userName),

                if (laporan.approvedByName != null &&
                    laporan.approvedByName!.isNotEmpty)
                  _detailRow('Diproses oleh', laporan.approvedByName!),

                if (laporan.createdAt != null)
                  _detailRow(
                    'Tanggal',
                    '${laporan.createdAt!.toLocal().day.toString().padLeft(2, '0')}/'
                        '${laporan.createdAt!.toLocal().month.toString().padLeft(2, '0')}/'
                        '${laporan.createdAt!.toLocal().year}',
                  ),

                const SizedBox(height: 10),

                const Text(
                  'Alasan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),

                const SizedBox(height: 5),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    laporan.reason,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ctrl.getStockChangeText(laporan),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  // =================================================================
  // DETAIL ROW
  // =================================================================

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),

          const Text(': ', style: TextStyle(color: Colors.grey, fontSize: 12)),

          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
