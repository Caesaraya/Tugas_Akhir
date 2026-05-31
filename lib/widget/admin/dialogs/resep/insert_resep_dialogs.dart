import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import '../../../../controller/admin/resep_table_controller.dart';
import '../custom_form_fields.dart';

class InsertResepDialog extends StatefulWidget {
  const InsertResepDialog({super.key});

  @override
  State<InsertResepDialog> createState() => _InsertResepDialogState();
}

class _InsertResepDialogState extends State<InsertResepDialog> {
  final ctrl = Get.find<ResepTableController>();
  final bahanBakuCtrl = Get.find<BahanBakuTableController>();

  final TextEditingController _bahanDropdownC = TextEditingController();

  static const Color _themeColor = Color(0xFF1E1E1E);

  @override
  void dispose() {
    _bahanDropdownC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DialogCommonTitle(
                title: 'Form Formulasi Resep Kue',
                icon: Icons.bakery_dining_rounded,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
              ),
              CustomTextField(
                controller: ctrl.namaResepC,
                label: 'Nama Formulasi Resep',
                icon: Icons.dinner_dining_outlined,
                hint: 'Contoh: Resep Blackforest Base 22cm',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: ctrl.deskripsiC,
                label: 'Deskripsi / Instruksi Singkat',
                icon: Icons.description_outlined,
                hint: 'Masukkan keterangan resep produksi',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Divider(thickness: 1),
              ),
              const Text(
                '🛠️ Tambah Komposisi Bahan Baku:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: _themeColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildAddBahanSection(),
              const SizedBox(height: 20),
              const Text(
                '📋 Daftar Bahan Terpilih di Resep ini:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: _themeColor,
                ),
              ),
              const SizedBox(height: 10),
              _buildTempBahanList(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(thickness: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      ctrl.clearForm();
                      Get.back();
                    },
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (ctrl.namaResepC.text.isEmpty ||
                          ctrl.tempBahanList.isEmpty) {
                        Get.snackbar(
                          'Peringatan',
                          'Nama resep dan minimal 1 takaran bahan harus diisi.',
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      // Menggunakan method bawaan BaseTableController
                      ctrl.submitResep();
                    },
                    child: const Text(
                      'Simpan Formula Resep',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddBahanSection() {
    // Membungkus dengan Obx agar dropdown terupdate otomatis saat data bahan baku masuk
    return Obx(() {
      // Pastikan data master bahan baku sudah di-fetch
      if (bahanBakuCtrl.originalList.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Memuat data bahan baku atau data kosong...',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        );
      }

      // Map data dari controller bahan baku
      final List<String> itemsBahan = bahanBakuCtrl.originalList
          .map((b) => "${b.id} - ${b.namaBahan} (${b.satuan})")
          .toList();

      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: CustomDropdownMenu(
              controller: _bahanDropdownC,
              label: 'Pilih Bahan Baku Utama',
              icon: Icons.compost_outlined,
              items: itemsBahan, // Sekarang items ini reaktif!
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: CustomTextField(
              controller: ctrl.jumlahBahanC,
              label: 'Takaran Kebutuhan',
              icon: Icons.scale_outlined,
              hint: '0.0',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5F5F5),
              foregroundColor: _themeColor,
              elevation: 0,
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (_bahanDropdownC.text.isEmpty) {
                Get.snackbar("Peringatan", "Pilih bahan baku terlebih dahulu.");
                return;
              }
              final String val = _bahanDropdownC.text;

              // SOLUSI AMAN TYPE DATA: Ambil teks angka ID paling depan
              final String rawId = val.split(' - ')[0];

              // Gunakan num.tryParse untuk menangani jika ada format string angka desimal (cth: "1.0")
              // lalu amankan konversinya menjadi .toInt() sesuai kebutuhan type model.
              final int? idBahan = num.tryParse(rawId)?.toInt();

              if (idBahan == null) {
                Get.snackbar("Error", "Format ID Bahan baku tidak valid.");
                return;
              }

              ctrl.selectedBahanId.value = idBahan;
              ctrl.addBahanToTempList();
              _bahanDropdownC.clear();
            },
            icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
            label: const Text(
              'Tambahkan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTempBahanList() {
    return Obx(() {
      if (ctrl.tempBahanList.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              style: BorderStyle.solid,
            ),
          ),
          child: const Center(
            child: Text(
              'Belum ada bahan baku yang dimasukkan ke formula resep ini.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        );
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ctrl.tempBahanList.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
        itemBuilder: (context, index) {
          final item = ctrl.tempBahanList[index];

          final masterBahan = bahanBakuCtrl.originalList.firstWhere(
            (b) => b.id == item.bahanId,
            orElse: () => bahanBakuCtrl.originalList.first,
          );

          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFF5F5F5),
              child: Icon(Icons.restaurant_menu_rounded, color: _themeColor),
            ),
            title: Text(
              masterBahan.namaBahan,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Kebutuhan: ${item.jumlahBahan} ${masterBahan.satuan}",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: () => ctrl.removeBahanFromTempList(index),
            ),
          );
        },
      );
    });
  }
}
