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

  static const Color _primaryColor = Color(0xFFE65100);

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
                title: 'Edit Resep: ${widget.resep.namaResep}',
                icon: Icons.edit_note_rounded,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(thickness: 1),
              ),

              CustomTextField(
                controller: ctrl.namaResepC,
                label: 'Nama Resep',
                icon: Icons.fastfood_rounded,
                hint: 'Nama resep',
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: ctrl.deskripsiC,
                label: 'Deskripsi Resep',
                icon: Icons.description_rounded,
                hint: 'Deskripsi atau cara olah resep...',
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(thickness: 1.5),
              ),

              const Text(
                'Ubah Komposisi Bahan Baku',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildAddBahanSection(),

              const SizedBox(height: 16),

              const Text(
                'Daftar Bahan Terpilih:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              _buildTempBahanList(),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(thickness: 1),
              ),

              DialogActionButtons(
                onCancel: () => Get.back(),
                onSave: () => ctrl.updateResepData(widget.resep),
                saveLabel: 'Update Resep',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddBahanSection() {
    final List<String> masterBahanNames = bahanBakuCtrl.originalList
        .map((b) => b.namaBahan)
        .toSet()
        .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: CustomDropdownMenu(
            controller: _bahanDropdownC,
            label: 'Pilih Bahan Baku',
            icon: Icons.inventory_2_rounded,
            items: masterBahanNames,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: CustomTextField(
            controller: ctrl.jumlahBahanC,
            label: 'Jumlah',
            icon: Icons.scale_rounded,
            hint: '0.0',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.black87, width: 1.5),
              ),
              elevation: 0,
            ),
            onPressed: () {
              final selectedName = _bahanDropdownC.text;
              try {
                final matchBahan = bahanBakuCtrl.originalList.firstWhere(
                  (b) => b.namaBahan == selectedName,
                );
                ctrl.selectedBahanId.value = matchBahan.id;
                ctrl.addBahanToTempList();
                _bahanDropdownC.clear();
              } catch (_) {
                Get.snackbar(
                  "Peringatan",
                  "Silahkan pilih bahan baku yang valid terlebih dahulu",
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              }
            },
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              'Tambah',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTempBahanList() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black26, width: 1.5),
      ),
      child: Obx(() {
        if (ctrl.tempBahanList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Belum ada komposisi bahan baku',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          itemCount: ctrl.tempBahanList.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = ctrl.tempBahanList[index];

            // Menggunakan item.bahanId sesuai objek model resep.dart
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
                backgroundColor: Color(0xFFFFF3E0),
                child: Icon(
                  Icons.restaurant_menu_rounded,
                  color: _primaryColor,
                ),
              ),
              title: Text(
                namaBahan,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Jumlah Aturan: ${item.jumlahBahan}"),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
                onPressed: () => ctrl.removeBahanFromTemp(index),
              ),
            );
          },
        );
      }),
    );
  }
}
