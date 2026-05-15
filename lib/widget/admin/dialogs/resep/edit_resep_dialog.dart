import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import '../../../../controller/admin/resep_table_controller.dart';
import '../../../../models/resep.dart';

class EditResepDialog extends StatelessWidget {
  final Resep resep;
  EditResepDialog({super.key, required this.resep});

  final ctrl = Get.find<ResepTableController>();
  final bahanBakuCtrl = Get.find<BahanBakuTableController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Resep: ${resep.namaResep}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              const SizedBox(height: 16),

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
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Kelola Komposisi Bahan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Bar Input Bahan (Sama dengan Insert)
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Obx(
                      () => DropdownButtonFormField<int>(
                        value: ctrl.selectedBahanId.value,
                        decoration: const InputDecoration(
                          labelText: 'Pilih Bahan Baku',
                          border: OutlineInputBorder(),
                        ),
                        items: bahanBakuCtrl.originalList.map((b) {
                          return DropdownMenuItem(
                            value: b.id,
                            child: Text("${b.namaBahan} (${b.merk})"),
                          );
                        }).toList(),
                        onChanged: (val) => ctrl.selectedBahanId.value = val,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: ctrl.jumlahBahanC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () => ctrl.addBahanToTempList(),
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.blue,
                      size: 35,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Di dalam EditResepDialog
              Obx(() {
                if (ctrl.tempBahanList.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Tidak ada bahan dalam resep ini"),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true, // Agar ListView mengikuti ukuran konten
                  physics:
                      const NeverScrollableScrollPhysics(), // Scroll utama ditangani SingleChildScrollView dialog
                  itemCount: ctrl.tempBahanList.length,
                  itemBuilder: (context, index) {
                    final item = ctrl.tempBahanList[index];

                    // Cari nama bahan dari master data bahan baku
                    String namaBahan = "Bahan ID: ${item.bahanId}";
                    try {
                      final master = bahanBakuCtrl.originalList.firstWhere(
                        (b) => b.id == item.bahanId,
                      );
                      namaBahan = master.namaBahan;
                    } catch (_) {
                      // Jika tidak ketemu di master, gunakan namaBahan dari item resep
                      namaBahan = item.namaBahan ?? namaBahan;
                    }

                    return ListTile(
                      title: Text(namaBahan),
                      subtitle: Text("Jumlah: ${item.jumlahBahan}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => ctrl.removeBahanFromTemp(index),
                      ),
                    );
                  },
                );
              }),

              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => ctrl.updateResepData(resep),
                    child: const Text('Update Resep'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
