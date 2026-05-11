// lib/controllers/product_controller.dart

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/api service/api_service.dart';

class ProductAdminController extends GetxController {
  final RxList<Product> _allProducts = <Product>[].obs;
  final RxList<Product> displayedProducts = <Product>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isFilteringOutOfStock = false.obs;
  final RxString searchQuery = ''.obs;

  final TextEditingController searchController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // =========================
  // FETCH PRODUCTS
  // =========================

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final data = await ApiService.getProducts();

      _allProducts.assignAll(data);

      _applyFilters();
    } catch (e) {
      Get.snackbar(
        'Gagal Memuat',
        'Tidak dapat mengambil data produk\n$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // SEARCH
  // =========================

  void onSearchChanged(String query) {
    searchQuery.value = query.trim().toLowerCase();

    _applyFilters();
  }

  void clearSearch() {
    searchController.clear();

    searchQuery.value = '';

    _applyFilters();
  }

  // =========================
  // FILTER
  // =========================

  void toggleOutOfStockFilter() {
    isFilteringOutOfStock.value = !isFilteringOutOfStock.value;

    _applyFilters();
  }

  void _applyFilters() {
    List<Product> result = List.from(_allProducts);

    if (isFilteringOutOfStock.value) {
      result = result.where((product) => product.stock <= 0).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      result = result.where((product) {
        return product.name.toLowerCase().contains(searchQuery.value);
      }).toList();
    }

    displayedProducts.assignAll(result);
  }

  // =========================
  // BARCODE
  // =========================

  String _generateBarcode() {
    final random = Random();

    return List.generate(12, (_) => random.nextInt(10)).join();
  }

  // =========================
  // IMAGE PICKER
  // =========================

  Future<XFile?> _pickImage() async {
    return await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1000,
    );
  }

  // =========================
  // CREATE
  // =========================

  void showCreateDialog() {
    _showProductDialog();
  }

  // =========================
  // EDIT
  // =========================

  void showEditDialog(Product product) {
    _showProductDialog(existingProduct: product);
  }

  // =========================
  // DELETE
  // =========================

  void confirmDelete(Product product) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Yakin ingin menghapus "${product.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back();

              await _deleteProduct(product);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(Product product) async {
    try {
      isLoading.value = true;

      final success = await ApiService.deleteProduct(product.id);

      if (!success) {
        throw Exception('Gagal menghapus produk');
      }

      _allProducts.removeWhere((p) => p.id == product.id);

      _applyFilters();

      Get.snackbar(
        'Berhasil',
        '${product.name} berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // PRODUCT DIALOG
  // =========================

  void _showProductDialog({Product? existingProduct}) {
    final bool isEdit = existingProduct != null;

    final formKey = GlobalKey<FormState>();

    final nameCtrl = TextEditingController(text: existingProduct?.name ?? '');

    final priceCtrl = TextEditingController(
      text: existingProduct?.price.toString() ?? '',
    );

    final stockCtrl = TextEditingController(
      text: existingProduct?.stock.toString() ?? '',
    );

    final discountCtrl = TextEditingController(
      text: existingProduct?.discount.toString() ?? '0',
    );

    final jenisCtrl = TextEditingController(text: existingProduct?.jenis ?? '');

    final satuanCtrl = TextEditingController(
      text: existingProduct?.satuan ?? '',
    );

    final barcodeCtrl = TextEditingController(
      text: isEdit ? existingProduct.barcode : _generateBarcode(),
    );

    final Rx<XFile?> pickedImage = Rx<XFile?>(null);

    final RxString currentImage = RxString(existingProduct?.image ?? '');

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? 'Edit Produk' : 'Tambah Produk',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _ImagePickerField(
                  pickedImage: pickedImage,
                  currentImageUrl: currentImage,
                  onPick: () async {
                    final file = await _pickImage();

                    if (file != null) {
                      pickedImage.value = file;
                    }
                  },
                  onRemove: () {
                    pickedImage.value = null;
                    currentImage.value = '';
                  },
                ),

                const SizedBox(height: 16),

                _buildTextField(nameCtrl, 'Nama Produk', required: true),

                const SizedBox(height: 12),

                _buildTextField(
                  priceCtrl,
                  'Harga',
                  isNumber: true,
                  required: true,
                ),

                const SizedBox(height: 12),

                _buildTextField(
                  stockCtrl,
                  'Stok',
                  isNumber: true,
                  required: true,
                ),

                const SizedBox(height: 12),

                _buildTextField(discountCtrl, 'Diskon', isNumber: true),

                const SizedBox(height: 12),

                _buildTextField(jenisCtrl, 'Jenis'),

                const SizedBox(height: 12),

                _buildTextField(satuanCtrl, 'Satuan'),

                const SizedBox(height: 12),

                _BarcodeField(controller: barcodeCtrl, isLocked: isEdit),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Batal'),
                    ),

                    const SizedBox(width: 8),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        Get.back();

                        final product = Product(
                          id: existingProduct?.id ?? 0,
                          name: nameCtrl.text.trim(),
                          price: int.tryParse(priceCtrl.text) ?? 0,
                          discount: int.tryParse(discountCtrl.text) ?? 0,
                          stock: int.tryParse(stockCtrl.text) ?? 0,
                          jenis: jenisCtrl.text.trim(),
                          satuan: satuanCtrl.text.trim(),
                          barcode: barcodeCtrl.text.trim(),
                          image: pickedImage.value?.path ?? currentImage.value,
                          resepId: existingProduct?.resepId,
                        );

                        if (isEdit) {
                          await _updateProduct(product);
                        } else {
                          await _createProduct(product);
                        }
                      },
                      child: Text(isEdit ? 'Simpan' : 'Tambah'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // CREATE PRODUCT
  // =========================

  Future<void> _createProduct(Product product) async {
    try {
      isLoading.value = true;

      final success = await ApiService.createProduct(product);

      if (!success) {
        throw Exception('Gagal menambah produk');
      }

      await fetchProducts();

      Get.snackbar(
        'Berhasil',
        '${product.name} berhasil ditambahkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // UPDATE PRODUCT
  // =========================

  Future<void> _updateProduct(Product product) async {
    try {
      isLoading.value = true;

      final success = await ApiService.updateProduct(product);

      if (!success) {
        throw Exception('Gagal update produk');
      }

      await fetchProducts();

      Get.snackbar(
        'Berhasil',
        '${product.name} berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // TEXT FIELD
  // =========================

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return '$label wajib diisi';
        }

        return null;
      },
    );
  }

  // =========================
  // FORMAT RUPIAH
  // =========================

  String formatRupiah(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );

    return 'Rp$formatted';
  }
}

// =========================
// IMAGE PICKER FIELD
// =========================

class _ImagePickerField extends StatelessWidget {
  const _ImagePickerField({
    required this.pickedImage,
    required this.currentImageUrl,
    required this.onPick,
    required this.onRemove,
  });

  final Rx<XFile?> pickedImage;
  final RxString currentImageUrl;

  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasNewImage = pickedImage.value != null;

      final hasOldImage = currentImageUrl.value.isNotEmpty;

      return GestureDetector(
        onTap: onPick,
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: hasNewImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(pickedImage.value!.path),
                    fit: BoxFit.cover,
                  ),
                )
              : hasOldImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    currentImageUrl.value,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return const Center(child: Icon(Icons.broken_image));
                    },
                  ),
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, size: 40),
                      SizedBox(height: 8),
                      Text('Pilih Foto'),
                    ],
                  ),
                ),
        ),
      );
    });
  }
}

// =========================
// BARCODE FIELD
// =========================

class _BarcodeField extends StatelessWidget {
  const _BarcodeField({required this.controller, required this.isLocked});

  final TextEditingController controller;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: isLocked,
      decoration: InputDecoration(
        labelText: 'Barcode',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.qr_code),
      ),
    );
  }
}
