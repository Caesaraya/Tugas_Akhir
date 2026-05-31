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
  ProductTableController() {
    itemsPerPage = 35;
    priceC.addListener(() {
      final raw = priceC.text;
      final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
      if (clean.isEmpty) return;
      final value = int.tryParse(clean) ?? 0;
      final formatted = currencyFormatter.format(value);
      if (formatted != raw) {
        priceC.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    });
  }

  final nameC = TextEditingController();
  final priceC = TextEditingController();
  final discountC = TextEditingController();
  final stockC = TextEditingController();
  final jenisC = TextEditingController();
  final satuanC = TextEditingController();
  final barcodeC = TextEditingController();

  final Rx<File?> selectedImage = Rx<File?>(null);

  final picker = ImagePicker();
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final data = await ApiService.getProducts();

      // DIUBAH: Logic Sorting. Produk Aktif di atas, Dihapus di bawah
      data.sort((a, b) {
        if (a.isDeleted && !b.isDeleted) return 1;
        if (!a.isDeleted && b.isDeleted) return -1;
        return a.id.compareTo(b.id); // Default urutan berdasar ID
      });

      setData(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data produk: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void search(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(originalList);
    } else {
      final searchText = query.toLowerCase();

      filteredList.assignAll(
        originalList.where((product) {
          final matchesString =
              product.name.toLowerCase().contains(searchText) ||
              product.barcode.toLowerCase().contains(searchText) ||
              product.jenis.toLowerCase().contains(searchText) ||
              product.satuan.toLowerCase().contains(searchText);

          final matchesNumbers =
              product.price.toString().contains(searchText) ||
              product.stock.toString().contains(searchText) ||
              product.discount.toString().contains(searchText) ||
              product.priceAfterDiscount.toString().contains(searchText);

          final matchesResep =
              product.resepId?.toString().contains(searchText) ?? false;

          // DIUBAH: Tambahan filter search berdasarkan status
          final statusString = product.isDeleted ? 'dihapus' : 'aktif';
          final matchesStatus = statusString.contains(searchText);

          return matchesString ||
              matchesNumbers ||
              matchesResep ||
              matchesStatus;
        }).toList(),
      );
    }

    currentPage.value = 1;
    setupPagination();
  }

  var isFilterStockHabis = false.obs;

  void toggleFilterStockHabis() {
    isFilterStockHabis.value = !isFilterStockHabis.value;

    if (isFilterStockHabis.value) {
      filteredList.assignAll(originalList.where((e) => e.stock <= 0).toList());
    } else {
      filteredList.assignAll(originalList);
    }

    currentPage.value = 1;
    setupPagination();
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  String generateBarcode() {
    final random = Random();
    return List.generate(12, (index) => random.nextInt(10)).join();
  }

  Future<void> insertProduct() async {
    try {
      if (selectedImage.value == null) {
        Get.snackbar('Error', 'Pilih gambar terlebih dahulu');
        return;
      }

      await ApiService.createProductWithImage(
        name: nameC.text,
        price: int.parse(priceC.text.replaceAll(RegExp(r'[^0-9]'), '')),
        discount: int.parse(discountC.text),
        stock: int.parse(stockC.text),
        jenis: jenisC.text,
        satuan: satuanC.text,
        barcode: generateBarcode(),
        imageFile: selectedImage.value!,
      );

      clearForm();
      fetchData();
      Get.back();
      Get.snackbar('Sukses', 'Produk berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void clearForm() {
    nameC.clear();
    priceC.clear();
    discountC.clear();
    stockC.clear();
    jenisC.clear();
    satuanC.clear();
    selectedImage.value = null;
  }

  var oldImageUrl = ''.obs;

  void openEditDialog(Product product) {
    if (product.isDeleted)
      return; // Proteksi agar produk dihapus tidak bisa diedit

    nameC.text = product.name;
    priceC.text = currencyFormatter.format(product.price);
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
        price: int.parse(priceC.text.replaceAll(RegExp(r'[^0-9]'), '')),
        discount: int.parse(discountC.text),
        stock: int.parse(stockC.text),
        jenis: jenisC.text,
        satuan: satuanC.text,
        barcode: product.barcode,
        imageFile: selectedImage.value,
        resepId: product.resepId,
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

  // DITAMBAHKAN: Soft Delete
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
        Get.back(); // Tutup dialog
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

  // DITAMBAHKAN: Restore Product
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

  // DITAMBAHKAN: Force Delete
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
