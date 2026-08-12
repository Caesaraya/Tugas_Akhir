import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/lapor_produk_controller.dart';
import 'package:tugas_akhir/models/stock_adjustment_request.dart';

class LaporanRiwayatPage extends StatelessWidget {
  const LaporanRiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<LaporProdukController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),

      appBar: AppBar(
        title: const Text(
          'Riwayat Laporan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE89336),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: ctrl.fetchLaporan,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),

      body: Obx(() {
        if (ctrl.isLoadingLaporan.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE89336)),
          );
        }

        final list = ctrl.laporanList;

        if (list.isEmpty) {
          return RefreshIndicator(
            onRefresh: ctrl.fetchLaporan,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 250),
                Center(
                  child: Text(
                    'Belum ada riwayat laporan',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: ctrl.fetchLaporan,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final laporan = list[index];

              return _MobileLaporanCard(laporan: laporan, ctrl: ctrl);
            },
          ),
        );
      }),
    );
  }
}

class _MobileLaporanCard extends StatelessWidget {
  final StockAdjustmentRequest laporan;
  final LaporProdukController ctrl;

  const _MobileLaporanCard({required this.laporan, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final status = laporan.status.toLowerCase();

    final statusColor = ctrl.getStatusColor(laporan.status);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => ctrl.showLaporanDetail(context, laporan),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
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
                      fontSize: 15,
                    ),
                  ),
                ),

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
                      Icon(
                        ctrl.getStatusIcon(laporan.status),
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ctrl.getStatusText(laporan.status),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 7),
                Text(
                  'Stock ${laporan.oldStock} → ${laporan.newStock}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              laporan.reason,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 10),

            if (laporan.createdAt != null)
              Text(
                DateFormat(
                  'dd MMM yyyy, HH:mm',
                ).format(laporan.createdAt!.toLocal()),
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),

            if (status == 'approved') ...[
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 17),
                    SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Diterima. Stok produk sudah diubah.',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (status == 'rejected') ...[
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.red, size: 17),
                    SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Ditolak. Stok produk tidak diubah.',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (status == 'pending') ...[
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.orange, size: 17),
                    SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Menunggu persetujuan admin.',
                        style: TextStyle(
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
}
