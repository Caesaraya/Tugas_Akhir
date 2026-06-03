import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import '../../../../controller/admin/resep_table_controller.dart';
import '../../../../models/resep.dart';
import '../custom_form_fields.dart';

class EditResepDialog extends StatefulWidget {
  final Resep resep;
  const EditResepDialog({super.key, required this.resep});

  @override
  State<EditResepDialog> createState() => _EditResepDialogState();
}

class _EditResepDialogState extends State<EditResepDialog> {
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
    return PopScope(
      canPop: true, // Mengizinkan dialog untuk tetap menutup secara normal
      onPopInvokedWithResult: (didPop, result) {
        // Blok ini akan dieksekusi saat dialog ditutup dengan cara APA PUN
        // termasuk klik area kosong di luar dialog atau tombol back sistem
        if (didPop) {
          ctrl.clearForm();
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DialogCommonTitle(
                  title: 'Edit Formula Resep',
                  icon: Icons.edit_note_rounded,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                ),

                // --- FORM UTAMA ---
                CustomTextField(
                  controller: ctrl.namaResepC,
                  label: 'Nama Resep / Menu',
                  hint: 'Contoh: Roti Manis Premium',
                  icon: Icons.restaurant_menu_rounded,
                  width: double.infinity,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: ctrl.deskripsiC,
                  label: 'Deskripsi / Catatan Produksi',
                  hint: 'Masukkan langkah singkat atau catatan porsi...',
                  icon: Icons.description_rounded,
                  width: double.infinity,
                ),
                const SizedBox(height: 24),

                // --- SEKSI FORM INPUT BAHAN ---
                _buildAddBahanSection(),
                const SizedBox(height: 16),

                // --- DAFTAR BAHAN YANG SUDAH MASUK FORMULA ---
                const Text(
                  "Komposisi Formula Bahan Baku",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _themeColor,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTempBahanList(),
                const SizedBox(height: 28),

                // --- ACTION BUTTONS DIALOG ---
                // --- ACTION BUTTONS DIALOG ---
                DialogActionButtons(
                  saveLabel: 'Simpan Perubahan',
                  onCancel: () {
                    // Cukup panggil Get.back(), pembersihan form sudah di-handle oleh PopScope di atas
                    Get.back();
                  },
                  onSave: () {
                    // PERUBAHAN: Validasi memastikan semua data terisi & minimal ada 1 bahan saat edit
                    if (ctrl.namaResepC.text.trim().isEmpty ||
                        ctrl.deskripsiC.text.trim().isEmpty ||
                        ctrl.tempBahanList.isEmpty) {
                      Get.snackbar(
                        'Peringatan',
                        'Semua data formulir wajib diisi dan tidak boleh menghapus semua bahan baku resep.',
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    if (widget.resep.id != null) {
                      ctrl.updateResep(widget.resep.id!);
                    } else {
                      Get.snackbar(
                        "Error",
                        "ID Resep tidak ditemukan.",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddBahanSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tambahkan Aturan Bahan Baku Baru",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Obx(() {
                  final listOptions = bahanBakuCtrl.originalList
                      .where((b) => b.deletedAt == null)
                      .map((b) => "${b.id} - ${b.namaBahan} (${b.satuan})")
                      .toList();

                  // FIX: Menggunakan CustomDropdownMenu dari custom_form_fields.dart
                  return CustomDropdownMenu(
                    controller: _bahanDropdownC,
                    label: 'Pilih Bahan Baku',

                    icon: Icons.search_rounded,
                    items: listOptions,
                  );
                }),
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
                  // TAMBAHKAN INI: Membatasi input hanya angka dan titik desimal
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _themeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Tambah',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (_bahanDropdownC.text.isEmpty) {
                      Get.snackbar(
                        "Peringatan",
                        "Pilih bahan baku terlebih dahulu.",
                      );
                      return;
                    }
                    final String val = _bahanDropdownC.text;
                    final String rawId = val.split(' - ')[0];
                    final int? idBahan = num.tryParse(rawId)?.toInt();

                    if (idBahan == null) {
                      Get.snackbar(
                        "Error",
                        "Format ID Bahan baku tidak valid.",
                      );
                      return;
                    }

                    ctrl.selectedBahanId.value = idBahan;
                    ctrl.addBahanToTempList();
                    _bahanDropdownC.clear();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTempBahanList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Obx(() {
        if (ctrl.tempBahanList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Belum ada bahan baku dalam resep ini.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: ctrl.tempBahanList.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: Color(0xFFF5F5F5)),
          itemBuilder: (context, index) {
            final item = ctrl.tempBahanList[index];
            String namaBahan = "Bahan #${item.bahanId}";

            try {
              final masterBahan = bahanBakuCtrl.originalList.firstWhere(
                (b) => b.id == item.bahanId,
              );
              namaBahan = "${masterBahan.namaBahan} (${masterBahan.satuan})";
            } catch (_) {
              namaBahan = item.namaBahan ?? namaBahan;
            }

            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF5F5F5),
                child: Icon(Icons.restaurant_menu_rounded, color: _themeColor),
              ),
              title: Text(
                namaBahan,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Jumlah Kebutuhan: ${item.jumlahBahan}"),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
                onPressed: () => ctrl.removeBahanFromTempList(index),
              ),
            );
          },
        );
      }),
    );
  }
}
