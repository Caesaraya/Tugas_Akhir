import 'package:flutter/material.dart';
import 'package:tugas_akhir/widget/admin/dialogs/custom_form_fields.dart';

class InsertBahanBakuDialog extends StatefulWidget {
  final List<String> units; // Contoh: ['Kg', 'Gram', 'Liter', 'Pcs']
  final Function(String) onAddNewUnit;
  final Function(Map<String, dynamic>) onSave;

  const InsertBahanBakuDialog({
    super.key,
    required this.units,
    required this.onAddNewUnit,
    required this.onSave,
  });

  @override
  State<InsertBahanBakuDialog> createState() => _InsertBahanBakuDialogState();
}

class _InsertBahanBakuDialogState extends State<InsertBahanBakuDialog> {
  final _namaController = TextEditingController();
  final _stokController = TextEditingController();
  final _satuanController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    _satuanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      title: const DialogCommonTitle(
        title: 'Tambah Bahan Baku',
        icon: Icons.inventory_2_rounded,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            CustomTextField(
              controller: _namaController,
              label: 'Nama Bahan Baku',
              hint: 'Contoh: Daging Ayam Fillet',
              icon: Icons.layers_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _stokController,
              label: 'Jumlah Stok Awal',
              hint: '0',
              icon: Icons.warehouse_rounded,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomDropdownField(
              controller: _satuanController,
              label: 'Satuan Ukur',
              hint: 'Pilih Satuan',
              icon: Icons.scale_rounded,
              items: widget.units,
              onAddNew: (newVal) {
                widget.onAddNewUnit(newVal);
                setState(() => _satuanController.text = newVal);
              },
            ),
            const SizedBox(height: 24),
            DialogActionButtons(
              saveLabel: 'Tambah',
              onCancel: () => Navigator.pop(context),
              onSave: () {
                if (_namaController.text.isNotEmpty &&
                    _stokController.text.isNotEmpty) {
                  widget.onSave({
                    'nama_bahan': _namaController.text.trim(),
                    'stok': double.tryParse(_stokController.text) ?? 0.0,
                    'satuan': _satuanController.text,
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
