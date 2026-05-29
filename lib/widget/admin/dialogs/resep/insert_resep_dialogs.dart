import 'package:flutter/material.dart';
import 'package:tugas_akhir/widget/admin/dialogs/custom_form_fields.dart';

class InsertResepDialog extends StatefulWidget {
  final List<String> products; // Daftar produk komersil
  final List<String> bahanBakus; // Daftar bahan mentah/baku
  final Function(String) onAddNewBahan;
  final Function(Map<String, dynamic>) onSave;

  const InsertResepDialog({
    super.key,
    required this.products,
    required this.bahanBakus,
    required this.onAddNewBahan,
    required this.onSave,
  });

  @override
  State<InsertResepDialog> createState() => _InsertResepDialogState();
}

class _InsertResepDialogState extends State<InsertResepDialog> {
  final _produkController = TextEditingController();
  final _bahanController = TextEditingController();
  final _takaranController = TextEditingController();

  @override
  void dispose() {
    _produkController.dispose();
    _bahanController.dispose();
    _takaranController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      title: const DialogCommonTitle(
        title: 'Formula Resep Baru',
        icon: Icons.receipt_long_rounded,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            // Hubungkan dengan Produk mana resep ini ditujukan
            CustomDropdownField(
              controller: _produkController,
              label: 'Untuk Produk',
              hint: 'Pilih Produk Jual',
              icon: Icons.restaurant_menu_rounded,
              items: widget.products,
              onAddNew:
                  (
                    _,
                  ) {}, // Kosongkan jika produk tidak boleh ditambah lewat sini
            ),
            const SizedBox(height: 16),
            // Pilih bahan baku yang digunakan dalam resep
            CustomDropdownField(
              controller: _bahanController,
              label: 'Komponen Bahan Baku',
              hint: 'Pilih Bahan Baku',
              icon: Icons.egg_rounded,
              items: widget.bahanBakus,
              onAddNew: (newVal) {
                widget.onAddNewBahan(newVal);
                setState(() => _bahanController.text = newVal);
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _takaranController,
              label: 'Jumlah Kebutuhan Takaran',
              hint: 'Contoh: 0.5 atau 200',
              icon: Icons.shutter_speed_outlined,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 24),
            DialogActionButtons(
              saveLabel: 'Simpan Resep',
              onCancel: () => Navigator.pop(context),
              onSave: () {
                if (_produkController.text.isNotEmpty &&
                    _bahanController.text.isNotEmpty &&
                    _takaranController.text.isNotEmpty) {
                  widget.onSave({
                    'nama_produk': _produkController.text,
                    'nama_bahan': _bahanController.text,
                    'takaran': double.tryParse(_takaranController.text) ?? 0.0,
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
