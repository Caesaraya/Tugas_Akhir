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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Riwayat Laporan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              IconButton(
                tooltip: 'Refresh',
                onPressed: ctrl.fetchLaporan,
                icon: const Icon(Icons.refresh, color: Color(0xFFE89336)),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Expanded(
            child: Obx(() {
              if (ctrl.isLoadingLaporan.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFE89336)),
                );
              }

              final list = ctrl.laporanList;

              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada laporan',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: ctrl.fetchLaporan,
                child: ListView.separated(
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

class _LaporanCard extends StatelessWidget {
  final StockAdjustmentRequest laporan;
  final LaporProdukController ctrl;

  const _LaporanCard({required this.laporan, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final status = laporan.status.toLowerCase();

    final Color statusColor = ctrl.getStatusColor(laporan.status);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => ctrl.showLaporanDetail(context, laporan),
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
            Row(
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

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ctrl.getStatusText(laporan.status),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Stock: ${laporan.oldStock} → ${laporan.newStock}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 5),

            Text(
              laporan.reason,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),

            if (laporan.createdAt != null) ...[
              const SizedBox(height: 7),
              Text(
                DateFormat(
                  'dd MMM yyyy, HH:mm',
                ).format(laporan.createdAt!.toLocal()),
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],

            if (status == 'approved') ...[
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.green, size: 15),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Stok sudah diubah',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            if (status == 'rejected') ...[
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.cancel, color: Colors.red, size: 15),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Stok tidak diubah',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
