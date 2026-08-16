import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/widget/admin/dialogs/custom_form_fields.dart';
import '../../../controller/admin/laporan_controller.dart';

class LaporanRejectDialog extends StatefulWidget {
  final int reportId;

  const LaporanRejectDialog({super.key, required this.reportId});

  @override
  State<LaporanRejectDialog> createState() => _LaporanRejectDialogState();
}

class _LaporanRejectDialogState extends State<LaporanRejectDialog> {
  final _reasonC = TextEditingController();
  final LaporanController _ctrl = LaporanController.to;
  bool _submitted = false;

  @override
  void dispose() {
    _reasonC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return AlertDialog(
      insetPadding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
          : const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
      ),
      title: const DialogCommonTitle(
        title: 'Alasan Penolakan',
        icon: Icons.block_outlined,
      ),
      content: SizedBox(
        width: isMobile ? double.maxFinite : 400,
        child: CustomTextField(
          controller: _reasonC,
          label: 'Alasan Penolakan',
          icon: Icons.edit_note_outlined,
          hint: 'Masukkan alasan penolakan',
          hasError: _submitted && _reasonC.text.trim().isEmpty,
          errorText: _submitted && _reasonC.text.trim().isEmpty
              ? 'Alasan penolakan wajib diisi'
              : null,
          onChanged: (_) {
            if (_submitted) setState(() {});
          },
        ),
      ),
      actionsPadding: const EdgeInsets.all(16),
      actions: [
        Obx(
          () => Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _ctrl.isProcessing.value ? null : () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _ctrl.isProcessing.value ? null : _handleReject,
                  child: _ctrl.isProcessing.value
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Tolak Laporan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleReject() async {
    setState(() => _submitted = true);
    final reason = _reasonC.text.trim();
    if (reason.isEmpty) return;

    final success = await _ctrl.rejectReport(widget.reportId, reason);
    if (success) {
      Get.back(); // tutup reject dialog
      Get.back(); // tutup detail dialog
      Get.snackbar(
        'Berhasil',
        'Laporan telah ditolak',
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Gagal',
        'Gagal menolak laporan',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
