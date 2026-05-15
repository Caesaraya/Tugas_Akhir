import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/admin/bahan_baku_table_controller.dart';

class InsertBahanBakuDialog extends StatelessWidget {
  InsertBahanBakuDialog({super.key});

  final ctrl = Get.find<BahanBakuTableController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Tambah Bahan Baku Baru',
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
                  hintText: 'Contoh: Gula Pasir',
                  prefixIcon: Icon(Icons.inventory),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl.merkC,
                decoration: const InputDecoration(
                  labelText: 'Merk',
                  hintText: 'Contoh: Gulaku',
                  prefixIcon: Icon(Icons.branding_watermark),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl.satuanC,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  hintText: 'Contoh: Kg, Pcs, Liter',
                  prefixIcon: Icon(Icons.ad_units),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl.stokC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stok Awal',
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
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Batal', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () {
            // Validasi sederhana sebelum insert
            if (ctrl.namaC.text.isEmpty || ctrl.stokC.text.isEmpty) {
              Get.snackbar(
                "Peringatan",
                "Nama dan Stok tidak boleh kosong",
                backgroundColor: Colors.orange,
              );
              return;
            }
            ctrl.insertBahanBaku();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Simpan Data'),
        ),
      ],
    );
  }
}
