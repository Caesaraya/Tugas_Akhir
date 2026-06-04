// lib/views/mobile/resep_form_mobile_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/controller/admin/resep_table_controller.dart';
import 'package:tugas_akhir/models/resep.dart';
import 'package:tugas_akhir/utils/app_color.dart';

class ResepFormMobilePage extends StatelessWidget {
  final bool isEdit;
  final Resep? resep;
  const ResepFormMobilePage({super.key, required this.isEdit, this.resep});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ResepTableController>();
    final bCtrl = Get.find<BahanBakuTableController>();

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Resep' : 'Tambah Resep')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: ctrl.namaResepC,
              decoration: const InputDecoration(
                labelText: 'Nama Resep',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl.deskripsiC,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bahan Baku',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddBahan(context, ctrl, bCtrl),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ctrl.tempBahanList.length,
                itemBuilder: (context, index) {
                  final item = ctrl.tempBahanList[index];
                  return ListTile(
                    title: Text("ID Bahan: ${item.bahanId}"),
                    subtitle: Text("Jumlah: ${item.jumlahBahan}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => ctrl.removeBahanFromTempList(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: AppColors.black,
          ),
          onPressed: () =>
              isEdit ? ctrl.updateResep(resep!.id!) : ctrl.submitResep(),
          child: const Text(
            'SIMPAN RESEP',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _showAddBahan(
    context,
    ResepTableController ctrl,
    BahanBakuTableController bCtrl,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tambah Bahan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(
              () => DropdownButtonFormField<int>(
                items: bCtrl.originalList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.namaBahan),
                      ),
                    )
                    .toList(),
                onChanged: (v) => ctrl.selectedBahanId.value = v,
                decoration: const InputDecoration(
                  labelText: 'Pilih Bahan',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl.jumlahBahanC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ctrl.addBahanToTempList();
                Get.back();
              },
              child: const Text('Tambahkan'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
