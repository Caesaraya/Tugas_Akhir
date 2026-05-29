import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/widget/admin/dialogs/custom_form_fields.dart';

class EditProductDialog extends StatefulWidget {
  final Map<String, dynamic> oldData;
  final List<String> categories;
  final Function(String) onAddNewCategory;
  final Function(Map<String, dynamic>) onUpdate;

  const EditProductDialog({
    super.key,
    required this.oldData,
    required this.categories,
    required this.onAddNewCategory,
    required this.onUpdate,
    required Product product,
  });

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController _namaController;
  late TextEditingController _hargaController;
  late TextEditingController _kategoriController;
  late bool _isAvailable;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.oldData['nama_produk'],
    );
    _hargaController = TextEditingController(
      text: widget.oldData['harga']?.toString(),
    );
    _kategoriController = TextEditingController(
      text: widget.oldData['kategori'],
    );
    _isAvailable = widget.oldData['is_available'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      title: const DialogCommonTitle(
        title: 'Ubah Data Produk',
        icon: Icons.edit_note_rounded,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            CustomTextField(
              controller: _namaController,
              label: 'Nama Produk',
              hint: 'Masukkan nama produk',
              icon: Icons.shopping_bag_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _hargaController,
              label: 'Harga Jual',
              hint: '0',
              icon: Icons.attach_money_rounded,
              keyboardType: TextInputType.number,
              prefixText: 'Rp ',
            ),
            const SizedBox(height: 16),
            CustomDropdownField(
              controller: _kategoriController,
              label: 'Kategori Produk',
              hint: 'Pilih Kategori',
              icon: Icons.grid_view_rounded,
              items: widget.categories,
              onAddNew: (newVal) {
                widget.onAddNewCategory(newVal);
                setState(() => _kategoriController.text = newVal);
              },
            ),
            const SizedBox(height: 16),
            CustomSwitchField(
              label: 'Status Produk Tersedia',
              value: _isAvailable,
              onChanged: (val) => setState(() => _isAvailable = val),
            ),
            const SizedBox(height: 24),
            DialogActionButtons(
              saveLabel: 'Simpan',
              onCancel: () => Navigator.pop(context),
              onSave: () {
                if (_namaController.text.isNotEmpty &&
                    _hargaController.text.isNotEmpty) {
                  widget.onUpdate({
                    'nama_produk': _namaController.text.trim(),
                    'harga': double.tryParse(_hargaController.text) ?? 0.0,
                    'kategori': _kategoriController.text,
                    'is_available': _isAvailable,
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
