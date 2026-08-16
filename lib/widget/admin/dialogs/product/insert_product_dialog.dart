import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _submitted = false;

  static const Color _themeColor = Color(0xFF1E1E1E);

  @override
  void initState() {
    super.initState();
    _ctrl.jenisC.addListener(_handleFieldChanged);
    _ctrl.satuanC.addListener(_handleFieldChanged);
    _ctrl.stockC.addListener(_handleFieldChanged);
  }

  @override
  void dispose() {
    _ctrl.jenisC.removeListener(_handleFieldChanged);
    _ctrl.satuanC.removeListener(_handleFieldChanged);
    _ctrl.stockC.removeListener(_handleFieldChanged);
    super.dispose();
  }

  void _handleFieldChanged() {
    if (_submitted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // --- RESPONSIF: Deteksi lebar layar ---
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final List<String> baseJenis = _getUniqueValues((p) => p.jenis);
    final List<String> baseSatuan = _getUniqueValues((p) => p.satuan);

    return AlertDialog(
      // --- RESPONSIF: Sesuaikan inset padding agar dialog tidak terpotong di mobile ---
      insetPadding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
          : const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
      ),
      titlePadding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 24,
        isMobile ? 16 : 20,
        isMobile ? 16 : 24,
        0,
      ),
      contentPadding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 24,
        isMobile ? 8 : 12,
        isMobile ? 16 : 24,
        0,
      ),
      title: const DialogCommonTitle(
        title: 'Tambah Produk Baru',
        icon: Icons.add_shopping_cart_rounded,
      ),
      content: SizedBox(
        // --- RESPONSIF: Lebar konten penuh di mobile ---
        width: isMobile ? double.maxFinite : 440,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              _buildImageSection(submitted: _submitted),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
              ),
              CustomTextField(
                controller: _ctrl.nameC,
                label: 'Nama Produk',
                icon: Icons.cake_outlined,
                hint: 'Masukkan nama produk',
                hasError: _submitted && _ctrl.nameC.text.trim().isEmpty,
                errorText: _submitted && _ctrl.nameC.text.trim().isEmpty
                    ? 'Nama produk wajib diisi'
                    : null,
                onChanged: (_) {
                  if (_submitted) setState(() {});
                },
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _ctrl.priceC,
                label: 'Harga Jual Base',
                icon: Icons.payments_outlined,
                hint: '0',
                prefixText: 'Rp ',
                keyboardType: TextInputType.number,
                hasError: _submitted && _ctrl.priceC.text.trim().isEmpty,
                errorText: _submitted && _ctrl.priceC.text.trim().isEmpty
                    ? 'Harga jual wajib diisi'
                    : null,
                onChanged: (_) {
                  if (_submitted) setState(() {});
                },
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _ctrl.discountC,
                label: 'Diskon Produk (%)',
                icon: Icons.percent_rounded,
                hint: '0',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.isEmpty) return newValue;
                    final int? val = int.tryParse(newValue.text);
                    if (val != null && val > 100) {
                      return const TextEditingValue(
                        text: '100',
                        selection: TextSelection.collapsed(offset: 3),
                      );
                    }
                    return newValue;
                  }),
                ],
              ),
              const SizedBox(height: 14),
              CustomStockStepper(
                controller: _ctrl.stockC,
                label: 'Stok Awal Kue',
                isDouble: false,
                hasError: _submitted && _ctrl.stockC.text.trim().isEmpty,
                errorText: _submitted && _ctrl.stockC.text.trim().isEmpty
                    ? 'Stok awal wajib diisi'
                    : null,
              ),
              const SizedBox(height: 14),
              CustomDropdownMenu(
                controller: _ctrl.jenisC,
                label: 'Kategori / Jenis',
                icon: Icons.category_outlined,
                items: [...baseJenis, ..._addedJenis],
                hasError: _submitted && _ctrl.jenisC.text.trim().isEmpty,
                errorText: _submitted && _ctrl.jenisC.text.trim().isEmpty
                    ? 'Kategori / jenis wajib diisi'
                    : null,
              ),
              const SizedBox(height: 14),
              CustomDropdownMenu(
                controller: _ctrl.satuanC,
                label: 'Satuan Jual',
                icon: Icons.layers_outlined,
                items: [...baseSatuan, ..._addedSatuan],
                hasError: _submitted && _ctrl.satuanC.text.trim().isEmpty,
                errorText: _submitted && _ctrl.satuanC.text.trim().isEmpty
                    ? 'Satuan jual wajib diisi'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: EdgeInsets.all(isMobile ? 12 : 16),
      actions: [
        // --- RESPONSIF: Di mobile tombol full-width vertikal, desktop horizontal ---
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSaveButton(),
                  const SizedBox(height: 8),
                  _buildCancelButton(),
                ],
              )
            : DialogActionButtons(
                onCancel: _onCancel,
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

  void _onCancel() {
    _ctrl.clearForm();
    Get.back();
  }

  void _handleSave() {
    setState(() {
      _submitted = true;
    });

    final isValid =
        _ctrl.nameC.text.trim().isNotEmpty &&
        _ctrl.priceC.text.trim().isNotEmpty &&
        _ctrl.stockC.text.trim().isNotEmpty &&
        _ctrl.jenisC.text.trim().isNotEmpty &&
        _ctrl.satuanC.text.trim().isNotEmpty &&
        _ctrl.selectedImage.value != null;

    if (!isValid) {
      return;
    }

    if (_ctrl.discountC.text.trim().isEmpty) {
      _ctrl.discountC.text = '0';
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

  Widget _buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _themeColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: _handleSave,
      child: const Text(
        'Simpan Produk',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: _onCancel,
      child: const Text(
        'Batal',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImageSection({bool submitted = false}) {
    return Center(
      child: Column(
        children: [
          Obx(() {
            final selectedImage = _ctrl.selectedImage.value;
            final bool hasImageError = submitted && selectedImage == null;
            return Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: hasImageError
                      ? Colors.red
                      : _themeColor.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: selectedImage != null
                    ? Image.file(selectedImage, fit: BoxFit.cover)
                    : Icon(
                        Icons.fastfood_rounded,
                        size: 48,
                        color: hasImageError ? Colors.red : _themeColor,
                      ),
              ),
            );
          }),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _ctrl.pickImage,
            icon: const Icon(Icons.camera_alt_rounded),
            label: const Text('Unggah Foto Produk'),
            style: TextButton.styleFrom(foregroundColor: _themeColor),
          ),
          Obx(() {
            final selectedImage = _ctrl.selectedImage.value;
            final bool hasImageError = submitted && selectedImage == null;
            if (!hasImageError) return const SizedBox.shrink();
            return const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Gambar produk wajib diunggah',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            );
          }),
        ],
      ),
    );
  }
}
