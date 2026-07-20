import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/admin/bahan_baku_table_controller.dart';
import '../../../../models/bahan_baku.dart';
import '../custom_form_fields.dart';

class EditBahanBakuDialog extends StatefulWidget {
  final BahanBaku item;
  const EditBahanBakuDialog({super.key, required this.item});

  @override
  State<EditBahanBakuDialog> createState() => _EditBahanBakuDialogState();
}

class _EditBahanBakuDialogState extends State<EditBahanBakuDialog> {
  final ctrl = Get.find<BahanBakuTableController>();
  final List<String> _addedSatuan = [];

  @override
  Widget build(BuildContext context) {
    // --- RESPONSIF: Deteksi lebar layar ---
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final List<String> baseSatuan = ctrl.originalList
        .map((b) => b.satuan.trim())
        .where((satuan) => satuan.isNotEmpty)
        .toSet()
        .toList();

    final List<String> dropdownSatuanItems = [...baseSatuan, ..._addedSatuan];

    return AlertDialog(
      // --- RESPONSIF: Hilangkan inset default agar bisa full-width di mobile ---
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
        title: 'Edit Bahan Baku',
        icon: Icons.edit_calendar_rounded,
      ),
      content: SizedBox(
        // --- RESPONSIF: Lebar konten menyesuaikan layar ---
        width: isMobile ? double.maxFinite : 440,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: ctrl.namaC,
                label: 'Nama Bahan Baku',
                icon: Icons.fastfood_outlined,
                hint: 'Masukkan nama bahan baku',
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: ctrl.merkC,
                label: 'Merk / Produsen',
                icon: Icons.branding_watermark_outlined,
                hint: 'Masukkan merk bahan baku',
              ),
              const SizedBox(height: 14),
              CustomDropdownMenu(
                controller: ctrl.satuanC,
                label: 'Satuan',
                icon: Icons.scale_outlined,
                items: dropdownSatuanItems,
              ),
              const SizedBox(height: 16),
              CustomStockStepper(
                controller: ctrl.stokC,
                label: 'Stok',
                isDouble: true,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: ctrl.hargaC,
                label: 'Harga Satuan',
                icon: Icons.payments_outlined,
                hint: '0',
                prefixText: 'Rp ',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: EdgeInsets.all(isMobile ? 12 : 16),
      actions: [
        // --- RESPONSIF: Di mobile tombol full-width vertikal, desktop horizontal ---
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSaveButton(context),
                  const SizedBox(height: 8),
                  _buildCancelButton(context),
                ],
              )
            : DialogActionButtons(
                onCancel: _onCancel,
                onSave: _onSave,
                saveLabel: 'Simpan Perubahan',
              ),
      ],
    );
  }

  void _onCancel() {
    ctrl.clearForm();
    Get.back();
  }

  // Cari baris fungsi _onSave di dalam edit_bahan_baku_dialog.dart Anda
  void _onSave() {
    if (ctrl.namaC.text.trim().isEmpty ||
        ctrl.stokC.text.trim().isEmpty ||
        ctrl.hargaC.text.trim().isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Form tidak boleh kosong',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (widget.item.id != null) {
      // MODIFIKASI: Menggunakan tracking pengeluaran berbasis data penambahan stok
      ctrl.updateBahanBaku(widget.item.id!);
    } else {
      Get.snackbar(
        'Error',
        'ID Bahan Baku tidak ditemukan',
        backgroundColor: Colors.red,
      );
    }
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: _onSave,
      child: const Text(
        'Simpan Perubahan',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: _onCancel,
      child: const Text(
        'Batal',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }
}
