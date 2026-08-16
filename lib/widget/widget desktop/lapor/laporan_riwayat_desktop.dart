import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:tugas_akhir/controller/lapor_produk_controller.dart';
import 'package:tugas_akhir/models/stock_adjustment_request.dart';

class LaporanRiwayatDesktop extends StatelessWidget {
  final LaporProdukController ctrl;

  const LaporanRiwayatDesktop({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // HEADER
          // =====================================================
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Riwayat Laporan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

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
                            strokeWidth: 2,
                            color: Color(0xFFE89336),
                          ),
                        )
                      : const Icon(Icons.refresh, color: Color(0xFFE89336)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // =====================================================
          // LIST RIWAYAT
          // =====================================================
          Expanded(
            child: Obx(() {
              if (ctrl.isLoadingHistory.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFE89336)),
                );
              }

              final list = ctrl.stockAdjustmentRequests;

              if (list.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 45,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Belum ada laporan',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
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
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final laporan = list[index];

                    return _LaporanCard(laporan: laporan, ctrl: ctrl);
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

// =============================================================
// CARD RIWAYAT LAPORAN
// =============================================================

class _LaporanCard extends StatelessWidget {
  final StockAdjustmentRequest laporan;
  final LaporProdukController ctrl;

  const _LaporanCard({required this.laporan, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final status = laporan.status.toLowerCase();

    final Color statusColor = ctrl.getStatusColor(laporan.status);

    final IconData statusIcon = ctrl.getStatusIcon(laporan.status);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _showDetail(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // NAMA PRODUK + STATUS
            // =================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    laporan.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
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

            const SizedBox(height: 8),

            // =================================================
            // PERUBAHAN STOCK
            // =================================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 16,
                    color: Color(0xFFE89336),
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'Stock:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${laporan.oldStock}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${laporan.newStock}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: status == 'approved'
                          ? Colors.green
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 7),

            // =================================================
            // ALASAN
            // =================================================
            Text(
              laporan.reason,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),

            // =================================================
            // TANGGAL
            // =================================================
            if (laporan.createdAt != null) ...[
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 13, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat(
                      'dd MMM yyyy, HH:mm',
                    ).format(laporan.createdAt!.toLocal()),
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ],

            // =================================================
            // APPROVED
            // =================================================
            if (status == 'approved') ...[
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        ctrl.getStockChangeText(laporan),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (laporan.approvedByName != null &&
                  laporan.approvedByName!.isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(
                  'Diproses oleh: ${laporan.approvedByName}',
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ],

            // =================================================
            // REJECTED
            // =================================================
            if (status == 'rejected') ...[
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cancel, color: Colors.red, size: 15),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        ctrl.getStockChangeText(laporan),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (laporan.approvedByName != null &&
                  laporan.approvedByName!.isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(
                  'Diproses oleh: ${laporan.approvedByName}',
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ],

            // =================================================
            // PENDING
            // =================================================
            if (status == 'pending') ...[
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.hourglass_top,
                      color: Colors.orange,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        ctrl.getStockChangeText(laporan),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // DETAIL LAPORAN
  // ===========================================================

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
                    'Tanggal Laporan',
                    DateFormat(
                      'dd MMM yyyy, HH:mm',
                    ).format(laporan.createdAt!.toLocal()),
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

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
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
