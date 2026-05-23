import 'package:flutter/material.dart';
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
              DialogCommonTitle(
                title: 'Ubah Formula Resep: ${widget.resep.namaResep}',
                icon: Icons.edit_note_rounded,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
              ),
              CustomTextField(
                controller: ctrl.namaResepC,
                label: 'Nama Formulasi Resep',
                icon: Icons.dinner_dining_outlined,
                hint: 'Masukkan nama resep',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: ctrl.deskripsiC,
                label: 'Deskripsi / Instruksi Singkat',
                icon: Icons.description_outlined,
                hint: 'Masukkan keterangan resep',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Divider(thickness: 1),
              ),
              const Text(
                '🛠️ Tambah Komposisi Bahan Baku Baru:',
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
                '📋 Daftar Komposisi Formula Saat Ini:',
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
                          'Nama resep dan minimal 1 takaran bahan harus terisi.',
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      if (widget.resep.id != null) {
                        // Menggunakan method bawaan BaseTableController
                        ctrl.updateResepData(widget.resep);
                      }
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
            label: 'Pilih Bahan Baku',
            icon: Icons.compost_outlined,
            items: itemsBahan,
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            if (_bahanDropdownC.text.isEmpty ||
                ctrl.jumlahBahanC.text.isEmpty) {
              Get.snackbar('Error', 'Pilih bahan baku dan takarannya.');
              return;
            }
            final parts = _bahanDropdownC.text.split(' - ');
            final int? idBahan = int.tryParse(parts[0]);
            final double? qty = double.tryParse(ctrl.jumlahBahanC.text);

            if (idBahan != null && qty != null) {
              ctrl.addBahanToTempList();
              _bahanDropdownC.clear();
              ctrl.jumlahBahanC.clear();
            }
          },
          icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
          label: const Text(
            'Tambahkan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
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
              'Belum ada komposisi bahan di resep ini.',
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
            subtitle: Text("Jumlah Aturan: ${item.jumlahBahan}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: () => ctrl.removeBahanFromTemp(index),
            ),
          );
        },
      );
    });
  }
}
