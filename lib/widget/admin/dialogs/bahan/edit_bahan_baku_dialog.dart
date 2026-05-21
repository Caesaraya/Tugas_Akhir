import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/admin/bahan_baku_table_controller.dart';
import '../../../../models/bahan_baku.dart';
import '../custom_form_fields.dart';

class EditBahanBakuDialog extends StatefulWidget {
  final BahanBaku bahan;
  const EditBahanBakuDialog({super.key, required this.bahan});

  @override
  State<EditBahanBakuDialog> createState() => _EditBahanBakuDialogState();
}

class _EditBahanBakuDialogState extends State<EditBahanBakuDialog> {
  final ctrl = Get.find<BahanBakuTableController>();
  final List<String> _addedSatuan = [];

  @override
  Widget build(BuildContext context) {
    // Ambil data unik satuan dari data model bahan baku yang ada
    final List<String> baseSatuan = ctrl.originalList
        .map((b) => b.satuan.trim())
        .where((satuan) => satuan.isNotEmpty)
        .toSet()
        .toList();

    final List<String> dropdownSatuanItems = [...baseSatuan, ..._addedSatuan];

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const DialogCommonTitle(
        title: 'Edit Bahan Baku',
        icon: Icons.edit_calendar_rounded,
      ),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              CustomTextField(
                controller: ctrl.namaC,
                label: 'Nama Bahan',
                icon: Icons.inventory_2,
                hint: 'Contoh: Tepung Terigu',
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: ctrl.merkC,
                label: 'Merk',
                icon: Icons.branding_watermark,
                hint: 'Contoh: Segitiga Biru',
              ),
              const SizedBox(height: 18),
              CustomDropdownMenu(
                controller: ctrl.satuanC,
                label: 'Satuan',
                icon: Icons.scale,
                items: dropdownSatuanItems,
              ),
              const SizedBox(height: 22),
              CustomStockStepper(
                controller: ctrl.stokC,
                label: 'Stok',
                isDouble: true,
              ),
              const SizedBox(height: 18),
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
      actionsPadding: const EdgeInsets.all(16),
      actions: [
        DialogActionButtons(
          onCancel: () {
            ctrl.clearForm();
            Get.back();
          },
          onSave: () {
            // Menggunakan widget.bahan sesuai dengan nama variabel di class utamanya
            if (widget.bahan.id != null) {
              final typedSatuan = ctrl.satuanC.text.trim();
              if (typedSatuan.isNotEmpty &&
                  !_addedSatuan.contains(typedSatuan)) {
                setState(() {
                  _addedSatuan.add(typedSatuan);
                });
              }
              ctrl.updateBahanBaku(
                widget.bahan.id!,
              ); // Menggunakan widget.bahan.id
            } else {
              Get.snackbar('Error', 'ID Bahan Baku tidak ditemukan');
            }
          },
          saveLabel: 'Simpan Perubahan',
        ),
      ],
    );
  }
}
