import 'package:flutter/material.dart';
import 'package:tugas_akhir/widget/admin/dialogs/custom_form_fields.dart';

class EditResepDialog extends StatefulWidget {
  final Map<String, dynamic> oldData;
  final List<String> products;
  final List<String> bahanBakus;
  final Function(String) onAddNewBahan;
  final Function(Map<String, dynamic>) onUpdate;

  const EditResepDialog({
    super.key,
    required this.oldData,
    required this.products,
    required this.bahanBakus,
    required this.onAddNewBahan,
    required this.onUpdate,
  });

  @override
  State<EditResepDialog> createState() => _EditResepDialogState();
}

class _EditResepDialogState extends State<EditResepDialog> {
  late TextEditingController _produkController;
  late TextEditingController _bahanController;
  late TextEditingController _takaranController;

  @override
  void initState() {
    super.initState();
    _produkController = TextEditingController(
      text: widget.oldData['nama_produk'],
    );
    _bahanController = TextEditingController(
      text: widget.oldData['nama_bahan'],
    );
    _takaranController = TextEditingController(
      text: widget.oldData['takaran']?.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      title: const DialogCommonTitle(
        title: 'Ubah Formula Resep',
        icon: Icons.menu_book_rounded,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            CustomDropdownField(
              controller: _produkController,
              label: 'Untuk Produk',
              hint: 'Pilih Produk Jual',
              icon: Icons.restaurant_menu_rounded,
              items: widget.products,
              onAddNew: (_) {},
            ),
            const SizedBox(height: 16),
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
              hint: 'Masukkan takaran baru',
              icon: Icons.shutter_speed_outlined,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 24),
            DialogActionButtons(
              saveLabel: 'Simpan Perubahan',
              onCancel: () => Navigator.pop(context),
              onSave: () {
                if (_produkController.text.isNotEmpty &&
                    _bahanController.text.isNotEmpty &&
                    _takaranController.text.isNotEmpty) {
                  widget.onUpdate({
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
