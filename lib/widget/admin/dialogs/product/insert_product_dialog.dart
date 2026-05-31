import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/admin/product_table_controller.dart';
import '../../../../models/product.dart';
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

  static const Color _themeColor = Color(0xFF1E1E1E);

  @override
  void initState() {
    super.initState();
    _ctrl.barcodeC.text = _ctrl.generateBarcode();
  }

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
                child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
              ),
              CustomTextField(
                controller: _ctrl.nameC,
                label: 'Nama Produk',
                icon: Icons.cake_outlined,
                hint: 'Masukkan nama produk',
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _ctrl.priceC,
                label: 'Harga Jual Base',
                icon: Icons.payments_outlined,
                hint: '0',
                prefixText: 'Rp ',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _ctrl.discountC,
                label: 'Diskon Produk (%)',
                icon: Icons.percent_rounded,
                hint: '0',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 18),
              CustomStockStepper(
                controller: _ctrl.stockC,
                label: 'Stok Awal Kue',
                isDouble: false,
              ),
              const SizedBox(height: 18),
              CustomDropdownMenu(
                controller: _ctrl.jenisC,
                label: 'Kategori / Jenis',
                icon: Icons.category_outlined,
                items: [...baseJenis, ..._addedJenis],
              ),
              const SizedBox(height: 18),
              CustomDropdownMenu(
                controller: _ctrl.satuanC,
                label: 'Satuan Jual',
                icon: Icons.layers_outlined,
                items: [...baseSatuan, ..._addedSatuan],
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _ctrl.barcodeC,
                label: 'Kode Barcode / SKU',
                icon: Icons.qr_code_scanner_rounded,
                hint: 'Scan atau ketik kode',
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
          onSave: _handleSave,
          saveLabel: 'Simpan Produk',
        ),
      ],
    );
  }

  List<String> _getUniqueValues(String Function(Product) mapper) {
    return _ctrl.originalList
        .cast<Product>()
        .where((p) => !p.isDeleted)
        .map(mapper)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
  }

  void _handleSave() {
    if (_ctrl.nameC.text.isEmpty || _ctrl.priceC.text.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Nama produk dan harga tidak boleh kosong",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    if (_ctrl.jenisC.text.trim().isNotEmpty &&
        !_addedJenis.contains(_ctrl.jenisC.text.trim())) {
      _addedJenis.add(_ctrl.jenisC.text.trim());
    }
    if (_ctrl.satuanC.text.trim().isNotEmpty &&
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
                  color: _themeColor.withOpacity(0.4),
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
                        color: _themeColor,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _ctrl.pickImage,
            icon: const Icon(Icons.camera_alt_rounded),
            label: const Text('Unggah Foto Produk'),
            style: TextButton.styleFrom(foregroundColor: _themeColor),
          ),
        ],
      ),
    );
  }
}
