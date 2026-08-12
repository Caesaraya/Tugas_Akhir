import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/admin/laporan_controller.dart';
import '../../../models/stock_adjustment_request.dart';
import 'laporan_reject_dialog.dart';
import 'package:tugas_akhir/widget/admin/dialogs/custom_form_fields.dart';
import 'status_badge.dart';

class LaporanDetailDialog extends StatelessWidget {
  final StockAdjustmentRequest report;

  const LaporanDetailDialog({super.key, required this.report});

  static const Color _themeColor = Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final selisih = report.newStock - report.oldStock;

    return AlertDialog(
      insetPadding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
          : const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
      ),
      titlePadding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 24,
        isMobile ? 16 : 20,
        isMobile ? 16 : 24,
        0,
      ),
      contentPadding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 24,
        isMobile ? 8 : 12,
        isMobile ? 16 : 24,
        0,
      ),
      title: const DialogCommonTitle(
        title: 'Detail Laporan',
        icon: Icons.assignment_outlined,
      ),
      content: SizedBox(
        width: isMobile ? double.maxFinite : 440,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: LaporanStatusBadge(status: report.status),
              ),
              const SizedBox(height: 16),
              _buildRow('Produk', report.productName),
              _buildRow('Kasir', report.userName),
              _buildRow('Stok Lama', report.oldStock.toString()),
              _buildRow('Stok Baru', report.newStock.toString()),
              _buildRow('Perubahan Stok', '${selisih > 0 ? '+' : ''}$selisih'),
              _buildRow('Alasan', report.reason),
              if (report.createdAt != null)
                _buildRow(
                  'Tanggal Laporan',
                  dateFormat.format(report.createdAt!),
                ),
              if (report.status != 'pending' && report.approvedByName != null)
                _buildRow('Diproses Oleh', report.approvedByName!),
            ],
          ),
        ),
      ),
      actionsPadding: EdgeInsets.all(isMobile ? 12 : 16),
      actions: [
        if (report.status == 'pending')
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildApproveButton(context),
                    const SizedBox(height: 8),
                    _buildRejectButton(context),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildRejectButton(context)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildApproveButton(context)),
                  ],
                )
        else
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApproveButton(BuildContext context) {
    final LaporanController ctrl = LaporanController.to;
    return Obx(
      () => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _themeColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: ctrl.isProcessing.value
            ? null
            : () async {
                final success = await ctrl.approveReport(report.id!);
                if (success) {
                  Get.back();
                  Get.snackbar(
                    'Berhasil',
                    'Laporan telah disetujui',
                    backgroundColor: Colors.black,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    'Gagal',
                    'Gagal menyetujui laporan',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
        child: ctrl.isProcessing.value
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Setujui',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildRejectButton(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(color: Colors.red),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => LaporanRejectDialog(reportId: report.id!),
        );
      },
      child: const Text(
        'Tolak',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}
