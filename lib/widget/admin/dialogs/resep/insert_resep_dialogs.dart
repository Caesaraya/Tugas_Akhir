import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import '../../../../controller/admin/resep_table_controller.dart';

class InsertResepDialog extends StatelessWidget {
  InsertResepDialog({super.key});

  final ctrl = Get.find<ResepTableController>();
  final bahanBakuCtrl =
      Get.find<BahanBakuTableController>(); // Untuk ambil master data bahan

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
              const Text(
                'Tambah Resep Baru',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 16),

              // Field Nama & Deskripsi
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
                'Tambah Komposisi Bahan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Input Bar untuk Bahan
              Row(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Menjaga posisi vertikal tetap sejajar di atas jika ada error text
                children: [
                  // 1. Dropdown Bahan Baku (Mengambil 3/4 bagian dari total lebar Row)
                  Expanded(
                    flex: 3,
                    child: Obx(
                      () => DropdownButtonFormField<int>(
                        isExpanded:
                            true, // PENTING: Mencegah overflow dengan memotong teks yang terlalu panjang (...)
                        value: ctrl.selectedBahanId.value,
                        decoration: const InputDecoration(
                          labelText: 'Pilih Bahan Baku',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ), // Padding agar tinggi seimbang
                        ),
                        items: bahanBakuCtrl.originalList.map((b) {
                          return DropdownMenuItem(
                            value: b.id,
                            child: Text(
                              "${b.namaBahan} (${b.merk})",
                              overflow: TextOverflow
                                  .ellipsis, // Memastikan teks dipotong dengan rapi menggunakan titik tiga (...)
                              maxLines: 1, // Membatasi teks hanya dalam 1 baris
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => ctrl.selectedBahanId.value = val,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // 2. TextField Jumlah (Mengambil 1/4 bagian dari total lebar Row)
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: ctrl.jumlahBahanC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // 3. Tombol Tambah (Icon Button)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ), // Sedikit offset agar ikon pas berada di tengah tinggi input field
                    child: IconButton(
                      onPressed: () => ctrl.addBahanToTempList(),
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.cyan,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // List Bahan yang ditambahkan
              const Text("Daftar Bahan:"),
              const SizedBox(height: 8),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ctrl.tempBahanList.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Belum ada bahan"),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: ctrl.tempBahanList.length,
                          itemBuilder: (context, index) {
                            final item = ctrl.tempBahanList[index];
                            // Cari nama bahan dari master data untuk display
                            final masterBahan = bahanBakuCtrl.originalList
                                .firstWhere((b) => b.id == item.bahanId);
                            return ListTile(
                              title: Text(masterBahan.namaBahan),
                              subtitle: Text(
                                "Jumlah: ${item.jumlahBahan} ${masterBahan.satuan}",
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    ctrl.removeBahanFromTemp(index),
                              ),
                            );
                          },
                        ),
                ),
              ),

              const SizedBox(height: 24),
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
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => ctrl.insertResep(),
                    child: const Text('Simpan Resep'),
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
