import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/admin/bahan_baku_table_controller.dart';
import '../custom_form_fields.dart';

class InsertBahanBakuDialog extends StatefulWidget {
  const InsertBahanBakuDialog({super.key});

  @override
  State<InsertBahanBakuDialog> createState() => _InsertBahanBakuDialogState();
}

class _InsertBahanBakuDialogState extends State<InsertBahanBakuDialog> {
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
        title: 'Tambah Bahan Baku Baru',
        icon: Icons.inventory_rounded,
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
                label: 'Stok Awal',
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
                  _buildSaveButton(),
                  const SizedBox(height: 8),
                  _buildCancelButton(),
                ],
              )
            : DialogActionButtons(
                onCancel: _onCancel,
                onSave: _onSave,
                saveLabel: 'Simpan Data',
              ),
      ],
    );
  }

  void _onCancel() {
    ctrl.clearForm();
    Get.back();
  }

  void _onSave() {
    if (ctrl.namaC.text.trim().isEmpty ||
        ctrl.merkC.text.trim().isEmpty ||
        ctrl.satuanC.text.trim().isEmpty ||
        ctrl.stokC.text.trim().isEmpty ||
        ctrl.hargaC.text.trim().isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Semua data formulir wajib diisi, tidak boleh ada yang kosong",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final typedSatuan = ctrl.satuanC.text.trim();
    if (typedSatuan.isNotEmpty && !_addedSatuan.contains(typedSatuan)) {
      setState(() {
        _addedSatuan.add(typedSatuan);
      });
    }
    ctrl.insertBahanBaku();
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: _onSave,
      child: const Text(
        'Simpan Data',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCancelButton() {
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
