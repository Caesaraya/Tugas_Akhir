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
    final controller = Get.find<ResepTableController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Detail Resep',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      // Menggunakan Obx agar halaman detail memantau perubahan data terbaru secara real-time seperti Detail Produk
      body: Obx(() {
        final latestResep = controller.originalList.firstWhere(
          (r) => r.id == resep.id,
          orElse: () => resep,
        );
        final bool isDeleted = latestResep.deletedAt != null;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            latestResep.namaResep,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDeleted ? Colors.grey : Colors.black,
                              decoration: isDeleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDeleted
                                ? Colors.red.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDeleted ? Colors.red : Colors.green,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            isDeleted ? "DIHAPUS" : "AKTIF",
                            style: TextStyle(
                              color: isDeleted
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      latestResep.deskripsi.isEmpty
                          ? "Tidak ada deskripsi."
                          : latestResep.deskripsi,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const Divider(height: 40),
                    const Text(
                      'Komposisi Bahan Baku',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (latestResep.bahan == null || latestResep.bahan!.isEmpty)
                      const Text(
                        "Tidak ada bahan baku dalam resep ini.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: latestResep.bahan!.length,
                        itemBuilder: (context, index) {
                          final b = latestResep.bahan![index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: ListTile(
                              title: Text(
                                b.namaBahan ?? 'Bahan #${b.bahanId}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "${b.merk ?? ''} • ${b.jumlahBahan} ${b.satuan ?? ''}",
                              ),
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
            ),

            // Bagian Aksi Dinamis Kontekstual di bawah layar (mengikuti template Product Detail Actions)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    if (!isDeleted) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.cyan),
                            foregroundColor: Colors.cyan,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.edit, size: 20),
                          label: const Text(
                            'Edit Resep',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            controller.namaResepC.text = latestResep.namaResep;
                            controller.deskripsiC.text = latestResep.deskripsi;
                            controller.tempBahanList.assignAll(
                              latestResep.bahan ?? [],
                            );
                            Get.to(
                              () => ResepFormMobilePage(
                                isEdit: true,
                                resep: latestResep,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.delete, size: 20),
                          label: const Text(
                            'Hapus',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () =>
                              controller.deleteData(latestResep.id!),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.green),
                            foregroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.restore, size: 20),
                          label: const Text(
                            'Restore',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () =>
                              controller.restoreData(latestResep.id!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade900,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.delete_forever, size: 20),
                          label: const Text(
                            'Hapus Permanen',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () =>
                              controller.forceDeleteData(latestResep.id!),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
