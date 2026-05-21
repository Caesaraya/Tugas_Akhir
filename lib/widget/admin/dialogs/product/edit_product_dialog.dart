import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/admin/product_table_controller.dart';
import '../../../../models/product.dart';
import '../custom_form_fields.dart'; // <--- IMPORT

class EditProductDialog extends StatefulWidget {
  final Product product;
  const EditProductDialog({super.key, required this.product});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
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
        title: 'Ubah Data Produk',
        icon: Icons.edit_note_rounded,
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
                hint: 'Nama',
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      controller: _ctrl.priceC,
                      label: 'Harga',
                      icon: Icons.payments_outlined,
                      hint: 'Harga',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: _ctrl.discountC,
                      label: 'Diskon',
                      icon: Icons.percent_rounded,
                      hint: 'Diskon',
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
                label: 'Jenis',
                icon: Icons.category_rounded,
                items: [...baseJenis, ..._addedJenis],
              ),
              const SizedBox(height: 18),
              CustomDropdownMenu(
                controller: _ctrl.satuanC,
                label: 'Satuan',
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
          onCancel: () {
            _ctrl.clearForm();
            Get.back();
          },
          onSave: () => _ctrl.updateProductData(widget.product),
          saveLabel: 'Update Data',
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
                  color: RumahLezaatTheme.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: _ctrl.selectedImage.value != null
                    ? Image.file(_ctrl.selectedImage.value!, fit: BoxFit.cover)
                    : (widget.product.image.isNotEmpty
                          ? Image.network(
                              widget.product.image,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.fastfood_rounded,
                              size: 48,
                              color: RumahLezaatTheme.primaryColor,
                            )),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: _ctrl.pickImage,
            icon: const Icon(Icons.image),
            label: const Text('Ganti Gambar'),
            style: TextButton.styleFrom(
              foregroundColor: RumahLezaatTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
