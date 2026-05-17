// lib/views/mobile/detail_resep_mobile_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/utils/currency.dart';
import 'package:tugas_akhir/controller/admin/resep_table_controller.dart';
import 'package:tugas_akhir/models/resep.dart';
import 'resep_form_mobile_page.dart';

class DetailResepMobilePage extends StatelessWidget {
  final Resep resep;
  const DetailResepMobilePage({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ResepTableController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Resep'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Set data ke form sebelum pindah halaman
              ctrl.namaResepC.text = resep.namaResep;
              ctrl.deskripsiC.text = resep.deskripsi;
              ctrl.tempBahanList.assignAll(resep.bahan ?? []);
              Get.to(() => ResepFormMobilePage(isEdit: true, resep: resep));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => ctrl.deleteData(resep.id!),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resep.namaResep,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              resep.deskripsi,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
            ),
            const Divider(height: 40),
            const Text(
              'Komposisi Bahan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: resep.bahan?.length ?? 0,
              itemBuilder: (context, index) {
                final b = resep.bahan![index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(b.namaBahan ?? 'Bahan #${b.bahanId}'),
                    subtitle: Text("${b.merk} • ${b.jumlahBahan} ${b.satuan}"),
                    trailing: Text(
                      formatRupiah(b.totalHargaBahan ?? 0),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
