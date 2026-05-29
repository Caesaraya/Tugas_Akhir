import 'package:flutter/material.dart';
import 'package:tugas_akhir/widget/admin/dialogs/custom_form_fields.dart';

class EditBahanBakuDialog extends StatefulWidget {
  final Map<String, dynamic> oldData;
  final List<String> units;
  final Function(String) onAddNewUnit;
  final Function(Map<String, dynamic>) onUpdate;

  const EditBahanBakuDialog({
    super.key,
    required this.oldData,
    required this.units,
    required this.onAddNewUnit,
    required this.onUpdate,
  });

  @override
  State<EditBahanBakuDialog> createState() => _EditBahanBakuDialogState();
}

class _EditBahanBakuDialogState extends State<EditBahanBakuDialog> {
  late TextEditingController _namaController;
  late TextEditingController _stokController;
  late TextEditingController _satuanController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.oldData['nama_bahan']);
    _stokController = TextEditingController(
      text: widget.oldData['stok']?.toString(),
    );
    _satuanController = TextEditingController(text: widget.oldData['satuan']);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      title: const DialogCommonTitle(
        title: 'Ubah Bahan Baku',
        icon: Icons.edit_attributes_rounded,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            CustomTextField(
              controller: _namaController,
              label: 'Nama Bahan Baku',
              hint: 'Masukkan nama bahan',
              icon: Icons.layers_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _stokController,
              label: 'Jumlah Stok',
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
              saveLabel: 'Simpan',
              onCancel: () => Navigator.pop(context),
              onSave: () {
                if (_namaController.text.isNotEmpty &&
                    _stokController.text.isNotEmpty) {
                  widget.onUpdate({
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
