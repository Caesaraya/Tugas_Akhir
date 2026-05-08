// lib/controllers/product_controller.dart
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/api service/api_service.dart';

class ProductController extends GetxController {
  // ─── State ───────────────────────────────────────────────
  final RxList<Product> _allProducts = <Product>[].obs;
  final RxList<Product> displayedProducts = <Product>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isFilteringOutOfStock = false.obs;
  final RxString searchQuery = ''.obs;

  final TextEditingController searchController = TextEditingController();

  // ─── Image Picker ─────────────────────────────────────────
  final ImagePicker _imagePicker = ImagePicker();

  // ─── Lifecycle ────────────────────────────────────────────
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

  // ─── Fetch / Refresh ──────────────────────────────────────
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final data = await ApiService.getProducts();
      _allProducts.assignAll(data);
      _applyFilters();
    } catch (e) {
      Get.snackbar(
        'Gagal Memuat',
        'Tidak dapat mengambil data produk: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Search ───────────────────────────────────────────────
  void onSearchChanged(String query) {
    searchQuery.value = query.trim().toLowerCase();
    _applyFilters();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _applyFilters();
  }

  // ─── Filter: Stok Habis ───────────────────────────────────
  void toggleOutOfStockFilter() {
    isFilteringOutOfStock.value = !isFilteringOutOfStock.value;
    _applyFilters();
  }

  // ─── Internal: Apply search + filter ─────────────────────
  void _applyFilters() {
    List<Product> result = List.from(_allProducts);

    if (isFilteringOutOfStock.value) {
      result = result.where((p) => p.stock <= 0).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      result = result
          .where((p) => p.name.toLowerCase().contains(searchQuery.value))
          .toList();
    }

    displayedProducts.assignAll(result);
  }

  // ─── Generate barcode random 12 digit ────────────────────
  String _generateBarcode() {
    final rand = Random();
    return List.generate(12, (_) => rand.nextInt(10)).join();
  }

  // ─── Pick image from gallery ──────────────────────────────
  Future<XFile?> _pickImage() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    return picked;
  }

  // ─── CREATE ───────────────────────────────────────────────
  void showCreateDialog() {
    _showProductDialog(null);
  }

  // ─── UPDATE ───────────────────────────────────────────────
  void showEditDialog(Product product) {
    _showProductDialog(product);
  }

  // ─── DELETE ───────────────────────────────────────────────
  void confirmDelete(Product product) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Hapus Produk'),
        content: Text('Apakah Anda yakin ingin menghapus "${product.name}"?'),
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
      if (success) {
        _allProducts.removeWhere((p) => p.id == product.id);
        _applyFilters();
        Get.snackbar(
          'Berhasil',
          '"${product.name}" telah dihapus.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Gagal menghapus produk');
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Menghapus',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Dialog Form (Create & Edit) ─────────────────────────
  void _showProductDialog(Product? existingProduct) {
    final isEdit = existingProduct != null;

    final nameCtrl = TextEditingController(text: existingProduct?.name ?? '');
    final priceCtrl = TextEditingController(
      text: existingProduct != null
          ? existingProduct.price.toStringAsFixed(0)
          : '',
    );
    final stockCtrl = TextEditingController(
      text: existingProduct?.stock.toString() ?? '',
    );
    final discountCtrl = TextEditingController(
      text: existingProduct != null
          ? existingProduct.discount.toStringAsFixed(0)
          : '0',
    );
    final jenisCtrl = TextEditingController(text: existingProduct?.jenis ?? '');
    final satuanCtrl = TextEditingController(
      text: existingProduct?.satuan ?? '',
    );

    // Barcode: auto-generate saat create, terkunci saat edit
    final String autoBarcode = isEdit
        ? (existingProduct.barcode ?? '')
        : _generateBarcode();
    final barcodeCtrl = TextEditingController(text: autoBarcode);

    // Image state — reactive di dalam dialog
    final Rx<XFile?> pickedImage = Rx<XFile?>(null);
    final RxString currentImageUrl = RxString(existingProduct?.image ?? '');

    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Judul dialog ──────────────────────────
                Text(
                  isEdit ? 'Edit Produk' : 'Tambah Produk',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Upload foto ───────────────────────────
                _ImagePickerField(
                  pickedImage: pickedImage,
                  currentImageUrl: currentImageUrl,
                  onPick: () async {
                    final file = await _pickImage();
                    if (file != null) pickedImage.value = file;
                  },
                  onRemove: () {
                    pickedImage.value = null;
                    currentImageUrl.value = '';
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
                _buildTextField(discountCtrl, 'Diskon (%)', isNumber: true),
                const SizedBox(height: 12),
                _buildTextField(jenisCtrl, 'Jenis'),
                const SizedBox(height: 12),
                _buildTextField(satuanCtrl, 'Satuan'),
                const SizedBox(height: 12),

                // ── Barcode: read-only saat edit ──────────
                _BarcodeField(controller: barcodeCtrl, isLocked: isEdit),
                const SizedBox(height: 24),

                // ── Tombol aksi ───────────────────────────
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        Get.back();

                        final product = Product(
                          id: existingProduct?.id ?? 0,
                          name: nameCtrl.text.trim(),
                          price: int.tryParse(priceCtrl.text) ?? 0,
                          stock: int.tryParse(stockCtrl.text) ?? 0,
                          discount: int.tryParse(discountCtrl.text) ?? 0,
                          jenis: jenisCtrl.text.trim(),
                          satuan: satuanCtrl.text.trim(),
                          barcode: barcodeCtrl.text.trim(),
                          // Tetap pakai URL lama jika tidak ganti foto
                          image:
                              pickedImage.value?.path ?? currentImageUrl.value,
                        );

                        if (isEdit) {
                          await _updateProduct(product, pickedImage.value);
                        } else {
                          await _createProduct(product, pickedImage.value);
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

  // ─── Text field biasa ─────────────────────────────────────
  Widget _buildTextField(
    TextEditingController ctrl,
    String label, {
    bool isNumber = false,
    bool required = false,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      validator: required
          ? (v) => (v == null || v.isEmpty) ? '$label tidak boleh kosong' : null
          : null,
    );
  }

  // ─── CREATE ───────────────────────────────────────────────
  Future<void> _createProduct(Product product, XFile? imageFile) async {
    try {
      isLoading.value = true;
      final success = await ApiService.createProduct(
        product,
        imageFile: imageFile,
      );
      if (success) {
        await fetchProducts();
        Get.snackbar(
          'Berhasil',
          '"${product.name}" berhasil ditambahkan.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Gagal menambah produk');
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Menambah',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ─── UPDATE ───────────────────────────────────────────────
  Future<void> _updateProduct(Product product, XFile? imageFile) async {
    try {
      isLoading.value = true;
      final success = await ApiService.updateProduct(
        product,
        imageFile: imageFile,
      );
      if (success) {
        final idx = _allProducts.indexWhere((p) => p.id == product.id);
        if (idx != -1) {
          _allProducts[idx] = product;
          _applyFilters();
        }
        Get.snackbar(
          'Berhasil',
          '"${product.name}" berhasil diperbarui.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Gagal memperbarui produk');
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Update',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Helpers ──────────────────────────────────────────────
  String formatRupiah(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp$formatted';
  }
}

// ═══════════════════════════════════════════════════════════
// Widget: Image Picker Field
// ═══════════════════════════════════════════════════════════
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
      final hasExistingImage = currentImageUrl.value.isNotEmpty;
      final hasAnyImage = hasNewImage || hasExistingImage;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Foto Produk',
            style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
          ),
          const SizedBox(height: 8),

          // Preview area
          GestureDetector(
            onTap: onPick,
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: hasAnyImage
                      ? const Color(0xFF2196F3)
                      : Colors.grey.shade300,
                  width: hasAnyImage ? 1.5 : 1,
                ),
              ),
              child: hasAnyImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Preview gambar
                          hasNewImage
                              ? Image.file(
                                  File(pickedImage.value!.path),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  currentImageUrl.value,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.broken_image_outlined,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                ),

                          // Overlay tombol hapus
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: onRemove,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.55),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),

                          // Overlay ganti foto
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              color: Colors.black.withOpacity(0.35),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Ganti Foto',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 36,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tap untuk pilih foto',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════
// Widget: Barcode Field (read-only saat edit)
// ═══════════════════════════════════════════════════════════
class _BarcodeField extends StatelessWidget {
  const _BarcodeField({required this.controller, required this.isLocked});

  final TextEditingController controller;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: isLocked,
      style: TextStyle(
        color: isLocked ? Colors.grey.shade600 : Colors.black,
        letterSpacing: isLocked ? 1.2 : 0,
      ),
      decoration: InputDecoration(
        labelText: 'Barcode',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        filled: isLocked,
        fillColor: isLocked ? Colors.grey.shade100 : null,
        prefixIcon: const Icon(Icons.qr_code, size: 20),
        suffixIcon: isLocked
            ? Tooltip(
                message: 'Barcode tidak dapat diubah',
                child: Icon(
                  Icons.lock_outline,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
              )
            : null,
        helperText: isLocked
            ? 'Barcode tidak dapat diubah setelah produk dibuat'
            : 'Barcode digenerate otomatis',
        helperStyle: TextStyle(fontSize: 11, color: Colors.grey.shade500),
      ),
    );
  }
}
