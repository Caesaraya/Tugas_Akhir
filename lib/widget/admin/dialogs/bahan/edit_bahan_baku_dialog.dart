import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/admin/bahan_baku_table_controller.dart';
import '../../../../models/bahan_baku.dart';

class EditBahanBakuDialog extends StatelessWidget {
  final BahanBaku bahan;

  EditBahanBakuDialog({super.key, required this.bahan});

  // Mencari instance controller yang sudah di-inject sebelumnya
  final ctrl = Get.find<BahanBakuTableController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Bahan Baku',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl.namaC,
                decoration: const InputDecoration(
                  labelText: 'Nama Bahan',
                  hintText: 'Contoh: Tepung Terigu',
                  prefixIcon: Icon(Icons.inventory_2),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl.merkC,
                decoration: const InputDecoration(
                  labelText: 'Merk',
                  hintText: 'Contoh: Segitiga Biru',
                  prefixIcon: Icon(Icons.branding_watermark),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl.satuanC,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  hintText: 'Contoh: Kg, Gram, Liter',
                  prefixIcon: Icon(Icons.ad_units),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl.stokC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl.hargaC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga Satuan',
                  prefixText: 'Rp ',
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Tombol Batal
        TextButton(
          onPressed: () {
            ctrl.clearForm();
            Get.back();
          },
          child: const Text('Batal', style: TextStyle(color: Colors.red)),
        ),
        // Tombol Update
        ElevatedButton(
          onPressed: () {
            if (bahan.id != null) {
              ctrl.updateBahanBaku(bahan.id!);
            } else {
              Get.snackbar('Error', 'ID Bahan Baku tidak ditemukan');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Simpan Perubahan'),
        ),
      ],
    );
  }
}
