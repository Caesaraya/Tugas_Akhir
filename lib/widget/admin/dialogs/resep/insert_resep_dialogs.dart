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
              const DialogCommonTitle(
                title: 'Tambah Resep Baru',
                icon: Icons.receipt_long_rounded,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(thickness: 1),
              ),

              CustomTextField(
                controller: ctrl.namaResepC,
                label: 'Nama Resep',
                icon: Icons.fastfood_rounded,
                hint: 'Masukkan nama resep menu',
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: ctrl.deskripsiC,
                label: 'Deskripsi / Cara Pembuatan',
                icon: Icons.description_rounded,
                hint: 'Masukkan langkah-langkah singkat pembuatan...',
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(thickness: 1.5),
              ),

              const Text(
                'Komposisi Bahan Baku',
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
                onSave: () => ctrl.insertResep(),
                saveLabel: 'Simpan Resep',
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
            label: 'Jumlah Kebutuhan',
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
                'Belum ada bahan baku yang ditambahkan',
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

            // Disesuaikan ke item.bahanId sesuai model resep.dart
            final masterBahan = bahanBakuCtrl.originalList.firstWhere(
              (b) => b.id == item.bahanId,
              orElse: () => bahanBakuCtrl.originalList.first,
            );

            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFF3E0),
                child: Icon(
                  Icons.restaurant_menu_rounded,
                  color: _primaryColor,
                ),
              ),
              title: Text(
                masterBahan.namaBahan,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Kebutuhan: ${item.jumlahBahan} ${masterBahan.satuan}",
              ),
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
