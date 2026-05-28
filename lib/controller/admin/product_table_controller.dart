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
    // Format harga saat user mengetik di field harga
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

      setData(data);
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
          // Cek string fields
          final matchesString =
              product.name.toLowerCase().contains(searchText) ||
              product.barcode.toLowerCase().contains(searchText) ||
              product.jenis.toLowerCase().contains(searchText) ||
              product.satuan.toLowerCase().contains(searchText);

          // Cek numeric fields (harga, stok, diskon)
          final matchesNumbers =
              product.price.toString().contains(searchText) ||
              product.stock.toString().contains(searchText) ||
              product.discount.toString().contains(searchText) ||
              product.priceAfterDiscount.toString().contains(searchText);

          // Tambahan: Cek ID resep jika ada
          final matchesResep =
              product.resepId?.toString().contains(searchText) ?? false;

          return matchesString || matchesNumbers || matchesResep;
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
      // Tampilkan hanya yang stoknya 0 atau kurang
      filteredList.assignAll(originalList.where((e) => e.stock <= 0).toList());
    } else {
      // Tampilkan semua data kembali
      filteredList.assignAll(originalList);
    }

    currentPage.value = 1;
    setupPagination();
  }

  Future<void> pickImage() async {
    // Contoh menggunakan image_picker
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      selectedImage.value = File(
        pickedFile.path,
      ); // Ini akan memicu UI untuk update previewnya
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

  // Method untuk membuka dialog dan mengisi form dengan data yang sudah ada
  void openEditDialog(Product product) {
    nameC.text = product.name;
    priceC.text = currencyFormatter.format(product.price);
    discountC.text = product.discount.toString();
    stockC.text = product.stock.toString();
    jenisC.text = product.jenis;
    satuanC.text = product.satuan;

    selectedImage.value = null; // Reset image picker
    oldImageUrl.value = product.image; // Set preview gambar dari server

    // Tampilkan dialog Edit (Pastikan kamu sudah membuat class EditProductDialog di bawah)
    Get.dialog(EditProductDialog(product: product));
  }

  // Method untuk mengirim data update ke API
  Future<void> updateProductData(Product product) async {
    try {
      // Tampilkan loading jika perlu
      // Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      await ApiService.updateProductWithImage(
        id: product.id,
        name: nameC.text,
        price: int.parse(priceC.text.replaceAll(RegExp(r'[^0-9]'), '')),
        discount: int.parse(discountC.text),
        stock: int.parse(stockC.text),
        jenis: jenisC.text,
        satuan: satuanC.text,
        barcode: product.barcode, // Pertahankan barcode lama
        imageFile: selectedImage
            .value, // Akan null jika user tidak pilih foto baru (API service sudah handle File?)
        resepId: product.resepId, // Pertahankan resepId lama
      );

      clearForm();
      fetchData(); // Refresh data tabel

      Get.back(); // Tutup dialog edit

      Get.snackbar(
        'Sukses',
        'Produk berhasil diperbarui',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Jika pakai loading dialog, tutup dulu sebelum memunculkan error
      // Get.back();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteData(int id) async {
    // Menampilkan Dialog Konfirmasi
    Get.defaultDialog(
      title: "Konfirmasi Hapus",
      middleText:
          "Apakah Anda yakin ingin menghapus produk ini? Data yang dihapus tidak dapat dikembalikan.",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onCancel: () {
        // Menutup dialog secara otomatis saat klik Batal
      },
      onConfirm: () async {
        // Tutup dialog terlebih dahulu
        Get.back();

        try {
          // Tampilkan loading indicator jika perlu
          // Get.showSnackbar(const GetSnackBar(message: "Sedang menghapus...", duration: Duration(seconds: 1)));

          bool success = await ApiService.deleteProduct(id);

          if (success) {
            Get.snackbar(
              "Berhasil",
              "Produk berhasil dihapus",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            // Refresh data setelah berhasil hapus
            fetchData();
          } else {
            throw Exception("Gagal menghapus produk di server");
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
}
