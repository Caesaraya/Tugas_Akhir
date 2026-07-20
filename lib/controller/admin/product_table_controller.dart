import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_akhir/widget/admin/dialogs/product/edit_product_dialog.dart';

import '../../api service/api_service.dart';
import '../../models/product.dart';
import '../../controller/admin/table/base_table_controller.dart';

class ProductTableController extends BaseTableController<Product> {
  // ── Constructor kosong, semua init pindah ke onInit ──────────────────────
  ProductTableController();

  final nameC = TextEditingController();
  final priceC = TextEditingController();
  final discountC = TextEditingController();
  final stockC = TextEditingController();
  final jenisC = TextEditingController();
  final satuanC = TextEditingController();
  final barcodeC = TextEditingController();

  final Rx<File?> selectedImage = Rx<File?>(null);
  var oldImageUrl = ''.obs;
  var isFilterStockHabis = false.obs;

  final picker = ImagePicker();

  // Formatter tanpa simbol, pemisah ribuan pakai titik (id_ID)
  final currencyFormatter = NumberFormat('#,###', 'id_ID');

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    itemsPerPage = 25;
    // Register listener sekali saja di sini, bukan di constructor
    priceC.addListener(_onPriceChanged);
    // Otomatis fetch data saat controller dibuat / di-recreate oleh fenix
    fetchData();
  }

  @override
  void onClose() {
    // Selalu remove listener sebelum dispose untuk menghindari memory leak
    priceC.removeListener(_onPriceChanged);
    // Dispose semua TextEditingController
    nameC.dispose();
    priceC.dispose();
    discountC.dispose();
    stockC.dispose();
    jenisC.dispose();
    satuanC.dispose();
    super.onClose();
  }

  // ── Price listener (dipindah dari constructor ke method terpisah) ─────────

  void _onPriceChanged() {
    final text = priceC.text;
    if (text.isEmpty) return;

    final clean = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.isEmpty) {
      priceC.value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      return;
    }

    final value = int.tryParse(clean) ?? 0;
    final formatted = _formatRibuan(value);

    // Hitung posisi kursor agar tidak melompat ke akhir secara paksa
    int cursorPosition = priceC.selection.baseOffset;
    int numCharsBeforeCursor = text
        .substring(0, max(0, cursorPosition))
        .replaceAll(RegExp(r'[^0-9]'), '')
        .length;

    int newCursorPosition = 0;
    int digitCount = 0;
    while (newCursorPosition < formatted.length &&
        digitCount < numCharsBeforeCursor) {
      if (RegExp(r'[0-9]').hasMatch(formatted[newCursorPosition])) {
        digitCount++;
      }
      newCursorPosition++;
    }

    if (formatted != text) {
      priceC.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(
          offset: min(newCursorPosition, formatted.length),
        ),
      );
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Format int ke string ribuan pakai titik, misal 100000 → "100.000"
  String _formatRibuan(int value) {
    return currencyFormatter.format(value);
  }

  /// Parse string ribuan kembali ke int, misal "100.000" → 100000
  int _parseRibuan(String text) {
    return int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  // ── Data ─────────────────────────────────────────────────────────────────
  void _sortProducts(List<Product> list) {
    list.sort((a, b) {
      // 1. Produk aktif terlebih dahulu, soft delete paling akhir
      if (a.isDeleted && !b.isDeleted) return 1;
      if (!a.isDeleted && b.isDeleted) return -1;

      // Jika keduanya berada di status yang sama (sama-sama aktif atau sama-sama deleted)
      if (!a.isDeleted && !b.isDeleted) {
        // 2. Stok 0 berada di bagian paling bawah dari produk aktif
        if (a.stock == 0 && b.stock > 0) return 1;
        if (a.stock > 0 && b.stock == 0) return -1;

        // 3. Urutkan berdasarkan stok terbanyak ke paling sedikit
        int stockCompare = b.stock.compareTo(a.stock);
        if (stockCompare != 0) return stockCompare;
      }

      // Jika stok sama atau keduanya soft delete, urutkan berdasarkan ID
      return a.id.compareTo(b.id);
    });
  }

  @override
  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final data = await ApiService.getProducts();

      // Gunakan fungsi helper sort baru
      _sortProducts(data);

      setData(data);

      // Jika filter stok habis sedang aktif saat refresh, terapkan ulang filter
      if (isFilterStockHabis.value) {
        filteredList.assignAll(
          originalList.where((e) => e.stock <= 0).toList(),
        );
        currentPage.value = 1;
        setupPagination();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data produk: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void search(String query) {
    if (query.isEmpty) {
      // Jika filter stok habis aktif, tampilkan stok habis saja
      if (isFilterStockHabis.value) {
        filteredList.assignAll(
          originalList.where((e) => e.stock <= 0).toList(),
        );
      } else {
        filteredList.assignAll(originalList);
      }
    } else {
      final searchText = query.toLowerCase();

      // Filter data terlebih dahulu berdasarkan query pencarian
      final searchResults = originalList.where((product) {
        final matchesString =
            product.name.toLowerCase().contains(searchText) ||
            product.jenis.toLowerCase().contains(searchText) ||
            product.satuan.toLowerCase().contains(searchText);

        final matchesNumbers =
            product.price.toString().contains(searchText) ||
            product.stock.toString().contains(searchText) ||
            product.discount.toString().contains(searchText) ||
            product.priceAfterDiscount.toString().contains(searchText);

        final matchesResep =
            product.resepId?.toString().contains(searchText) ?? false;

        final statusString = product.isDeleted ? 'dihapus' : 'aktif';
        final matchesStatus = statusString.contains(searchText);

        // Jika tombol filter stok habis aktif, hasil pencarian juga disaring hanya yang stok <= 0
        final matchesFilter = !isFilterStockHabis.value || product.stock <= 0;

        return (matchesString ||
                matchesNumbers ||
                matchesResep ||
                matchesStatus) &&
            matchesFilter;
      }).toList();

      // Terapkan pengurutan default pada hasil pencarian
      _sortProducts(searchResults);
      filteredList.assignAll(searchResults);
    }

    currentPage.value = 1;
    setupPagination();
  }

  void toggleFilterStockHabis() {
    isFilterStockHabis.value = !isFilterStockHabis.value;

    if (isFilterStockHabis.value) {
      // Hanya menampilkan produk dengan stok habis (stok = 0 atau kurang)
      filteredList.assignAll(originalList.where((e) => e.stock <= 0).toList());
    } else {
      // Ketika dimatikan, kembali menampilkan seluruh data dengan urutan default (karena originalList sudah terurut)
      filteredList.assignAll(originalList);
    }

    currentPage.value = 1;
    setupPagination();
  }

  // ── Fungsi Tambahan Navigasi Angka Langsung ──────────────────────────────

  // ── Image ────────────────────────────────────────────────────────────────

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  // ── Form ─────────────────────────────────────────────────────────────────

  void clearForm() {
    nameC.clear();
    priceC.clear();
    discountC.clear();
    stockC.clear();
    jenisC.clear();
    satuanC.clear();
    selectedImage.value = null;
  }

  // ── CRUD ─────────────────────────────────────────────────────────────────

  Future<void> insertProduct() async {
    try {
      if (selectedImage.value == null) {
        Get.snackbar('Error', 'Pilih gambar terlebih dahulu');
        return;
      }

      await ApiService.createProductWithImage(
        name: nameC.text,
        price: _parseRibuan(priceC.text),
        discount:
            int.tryParse(discountC.text) ?? 0, // FIX: tryParse bukan parse
        stock: int.tryParse(stockC.text) ?? 0, // FIX: tryParse bukan parse
        jenis: jenisC.text,
        satuan: satuanC.text,
        imageFile: selectedImage.value!,
      );

      clearForm();
      fetchData();
      Get.back();
      Get.snackbar(
        'Sukses',
        'Produk berhasil ditambahkan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void openEditDialog(Product product) {
    if (product.isDeleted) return;

    nameC.text = product.name;
    priceC.text = _formatRibuan(product.price);
    discountC.text = product.discount.toString();
    stockC.text = product.stock.toString();
    jenisC.text = product.jenis;
    satuanC.text = product.satuan;

    selectedImage.value = null;
    oldImageUrl.value = product.image;

    Get.dialog(EditProductDialog(product: product));
  }

  Future<void> updateProductData(Product product) async {
    try {
      await ApiService.updateProductWithImage(
        id: product.id,
        name: nameC.text,
        price: _parseRibuan(priceC.text),
        discount:
            int.tryParse(discountC.text) ?? 0, // FIX: tryParse bukan parse
        stock: int.tryParse(stockC.text) ?? 0, // FIX: tryParse bukan parse
        jenis: jenisC.text,
        satuan: satuanC.text,
        imageFile: selectedImage.value,
        resepId: product.resepId, // Pertahankan resepId lama
      );

      clearForm();
      fetchData();
      Get.back();

      Get.snackbar(
        'Sukses',
        'Produk berhasil diperbarui',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ── Delete / Restore ─────────────────────────────────────────────────────

  Future<void> softDeleteProduct(int id) async {
    Get.defaultDialog(
      title: "Konfirmasi Hapus",
      middleText:
          "Produk akan dipindahkan ke data terhapus dan masih dapat dipulihkan.\nLanjutkan?",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        try {
          bool success = await ApiService.softDeleteProduct(id);
          if (success) {
            Get.snackbar(
              "Berhasil",
              "Produk berhasil dihapus",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            fetchData();
          }
        } catch (e) {
          Get.snackbar(
            "Error",
            "Gagal menghapus data: $e",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }

  Future<void> restoreProduct(int id) async {
    Get.defaultDialog(
      title: "Konfirmasi Restore",
      middleText: "Apakah Anda yakin ingin memulihkan produk ini?",
      textConfirm: "Ya, Pulihkan",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () async {
        Get.back();
        try {
          bool success = await ApiService.restoreProduct(id);
          if (success) {
            Get.snackbar(
              "Berhasil",
              "Produk berhasil dipulihkan",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            fetchData();
          }
        } catch (e) {
          Get.snackbar(
            "Error",
            "Gagal memulihkan data: $e",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }

  Future<void> forceDeleteProduct(int id) async {
    Get.defaultDialog(
      title: "Hapus Permanen",
      middleText:
          "Data akan dihapus permanen dan tidak dapat dipulihkan.\nLanjutkan?",
      textConfirm: "Hapus Permanen",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red.shade900,
      onConfirm: () async {
        Get.back();
        try {
          bool success = await ApiService.forceDeleteProduct(id);
          if (success) {
            Get.snackbar(
              "Berhasil",
              "Produk dihapus secara permanen",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            fetchData();
          }
        } catch (e) {
          Get.snackbar(
            "Error",
            "Gagal menghapus data permanen: $e",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }
}
