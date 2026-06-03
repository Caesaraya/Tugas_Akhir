import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/admin/bahan_baku_table_controller.dart';
import '../../../../models/bahan_baku.dart';
import '../custom_form_fields.dart';

class EditBahanBakuDialog extends StatefulWidget {
  final BahanBaku
  item; // Menyesuaikan nama parameter model dengan parameter table action ('item')
  const EditBahanBakuDialog({super.key, required this.item});

  @override
  State<EditBahanBakuDialog> createState() => _EditBahanBakuDialogState();
}

class _EditBahanBakuDialogState extends State<EditBahanBakuDialog> {
  final ctrl = Get.find<BahanBakuTableController>();
  final List<String> _addedSatuan = [];

  @override
  Widget build(BuildContext context) {
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
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: ctrl.namaC,
                label: 'Nama Bahan Baku',
                icon: Icons.fastfood_outlined,
                hint: 'Masukkan nama bahan baku',
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: ctrl.merkC,
                label: 'Merk / Produsen',
                icon: Icons.branding_watermark_outlined,
                hint: 'Masukkan merk bahan baku',
              ),
              const SizedBox(height: 18),
              CustomDropdownMenu(
                controller: ctrl.satuanC,
                label: 'Satuan',
                icon: Icons.scale_outlined,
                items: dropdownSatuanItems,
              ),
              const SizedBox(height: 22),
              CustomStockStepper(
                controller: ctrl.stokC,
                label: 'Stok',
                isDouble:
                    true, // Mendukung tipe desimal/double untuk bahan baku pecahan
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
            // PERUBAHAN: Validasi memastikan semua field wajib diisi sebelum menyimpan perubahan
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

            if (widget.item.id != null) {
              final typedSatuan = ctrl.satuanC.text.trim();
              if (typedSatuan.isNotEmpty &&
                  !_addedSatuan.contains(typedSatuan)) {
                setState(() {
                  _addedSatuan.add(typedSatuan);
                });
              }
              // Mengeksekusi pembaruan data pada controller baru sesuai target ID
              ctrl.updateBahanBaku(widget.item.id!);
            } else {
              Get.snackbar(
                'Error',
                'ID Bahan Baku tidak ditemukan',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          saveLabel: 'Simpan Perubahan',
        ),
      ],
    );
  }
}
