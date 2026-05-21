import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/admin/product_table_controller.dart';
import '../custom_form_fields.dart';

class InsertProductDialog extends StatefulWidget {
  const InsertProductDialog({super.key});

  @override
  State<InsertProductDialog> createState() => _InsertProductDialogState();
}

class _InsertProductDialogState extends State<InsertProductDialog> {
  final _ctrl = Get.find<ProductTableController>();
  final List<String> _addedJenis = [];
  final List<String> _addedSatuan = [];

  @override
  Widget build(BuildContext context) {
    final List<String> baseJenis = _getUniqueValues((p) => p.jenis);
    final List<String> baseSatuan = _getUniqueValues((p) => p.satuan);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const DialogCommonTitle(
        title: 'Tambah Produk Baru',
        icon: Icons.add_shopping_cart_rounded,
      ),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              _buildImageSection(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(thickness: 1),
              ),
              CustomTextField(
                controller: _ctrl.nameC,
                label: 'Nama Produk',
                icon: Icons.shopping_bag_outlined,
                hint: 'Masukkan nama produk',
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      controller: _ctrl.priceC,
                      label: 'Harga Jual',
                      icon: Icons.payments_outlined,
                      hint: '0',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: _ctrl.discountC,
                      label: 'Diskon (%)',
                      icon: Icons.percent_rounded,
                      hint: '0',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              CustomStockStepper(controller: _ctrl.stockC),
              const SizedBox(height: 22),
              CustomDropdownMenu(
                controller: _ctrl.jenisC,
                label: 'Jenis Kategori',
                icon: Icons.category_rounded,
                items: [...baseJenis, ..._addedJenis],
              ),
              const SizedBox(height: 18),
              CustomDropdownMenu(
                controller: _ctrl.satuanC,
                label: 'Satuan Unit',
                icon: Icons.scale_rounded,
                items: [...baseSatuan, ..._addedSatuan],
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.all(16),
      actions: [
        DialogActionButtons(
          onCancel: () => Get.back(),
          onSave: _onSaveAndInsert,
          saveLabel: 'Simpan Produk',
        ),
      ],
    );
  }

  List<String> _getUniqueValues(String Function(dynamic) mapper) {
    return _ctrl.originalList
        .map(mapper)
        .map((val) => val.trim())
        .where((val) => val.isNotEmpty)
        .toSet()
        .toList();
  }

  void _onSaveAndInsert() {
    if (_ctrl.jenisC.text.isNotEmpty &&
        !_addedJenis.contains(_ctrl.jenisC.text.trim())) {
      _addedJenis.add(_ctrl.jenisC.text.trim());
    }
    if (_ctrl.satuanC.text.isNotEmpty &&
        !_addedSatuan.contains(_ctrl.satuanC.text.trim())) {
      _addedSatuan.add(_ctrl.satuanC.text.trim());
    }
    _ctrl.insertProduct();
  }

  Widget _buildImageSection() {
    return Center(
      child: Column(
        children: [
          Obx(
            () => Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: RumahLezaatTheme.primaryColor,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: _ctrl.selectedImage.value != null
                    ? Image.file(_ctrl.selectedImage.value!, fit: BoxFit.cover)
                    : const Icon(
                        Icons.fastfood_rounded,
                        size: 48,
                        color: RumahLezaatTheme.primaryColor,
                      ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: _ctrl.pickImage,
            icon: const Icon(Icons.camera_alt_rounded),
            label: const Text('Unggah Foto Produk'),
            style: TextButton.styleFrom(
              foregroundColor: RumahLezaatTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
