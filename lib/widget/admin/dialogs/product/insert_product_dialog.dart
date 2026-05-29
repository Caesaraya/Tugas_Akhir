import 'package:flutter/material.dart';
import 'package:tugas_akhir/widget/admin/dialogs/custom_form_fields.dart';

class InsertProductDialog extends StatefulWidget {
  final List<String> categories;
  final Function(String) onAddNewCategory;
  final Function(Map<String, dynamic>) onSave;

  const InsertProductDialog({
    super.key,
    required this.categories,
    required this.onAddNewCategory,
    required this.onSave,
  });

  @override
  State<InsertProductDialog> createState() => _InsertProductDialogState();
}

class _InsertProductDialogState extends State<InsertProductDialog> {
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _kategoriController = TextEditingController();
  bool _isAvailable = true;

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      title: const DialogCommonTitle(
        title: 'Tambah Produk Baru',
        icon: Icons.fastfood_rounded,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            CustomTextField(
              controller: _namaController,
              label: 'Nama Produk',
              hint: 'Contoh: Nasi Goreng Lezaat',
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
              saveLabel: 'Tambah',
              onCancel: () => Navigator.pop(context),
              onSave: () {
                if (_namaController.text.isNotEmpty &&
                    _hargaController.text.isNotEmpty) {
                  widget.onSave({
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
