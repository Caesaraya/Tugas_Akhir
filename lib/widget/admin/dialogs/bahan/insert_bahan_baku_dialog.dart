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
    // Ambil data unik satuan dari model bahan baku yang ada di database lokal/state controller
    final List<String> baseSatuan = ctrl.originalList
        .map((b) => b.satuan.trim())
        .where((satuan) => satuan.isNotEmpty)
        .toSet()
        .toList();

    final List<String> dropdownSatuanItems = [...baseSatuan, ..._addedSatuan];

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const DialogCommonTitle(
        title: 'Tambah Bahan Baku Baru',
        icon: Icons.inventory_rounded,
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
                icon: Icons.inventory,
                hint: 'Contoh: Gula Pasir',
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: ctrl.merkC,
                label: 'Merk',
                icon: Icons.branding_watermark,
                hint: 'Contoh: Gulaku',
              ),
              const SizedBox(height: 18),
              CustomDropdownMenu(
                controller: ctrl.satuanC,
                label: 'Satuan Unit',
                icon: Icons.scale_outlined,
                items: dropdownSatuanItems,
              ),
              const SizedBox(height: 22),
              CustomStockStepper(
                controller: ctrl.stokC,
                label: 'Stok Awal',
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
          onCancel: () => Get.back(),
          onSave: () {
            if (ctrl.namaC.text.isEmpty || ctrl.stokC.text.isEmpty) {
              Get.snackbar(
                "Peringatan",
                "Nama dan Stok tidak boleh kosong",
                backgroundColor: Colors.orange,
              );
              return;
            }
            // Simpan input satuan baru ke state local jika belum ada di list
            final typedSatuan = ctrl.satuanC.text.trim();
            if (typedSatuan.isNotEmpty && !_addedSatuan.contains(typedSatuan)) {
              setState(() {
                _addedSatuan.add(typedSatuan);
              });
            }
            ctrl.insertBahanBaku();
          },
          saveLabel: 'Simpan Data',
        ),
      ],
    );
  }
}
