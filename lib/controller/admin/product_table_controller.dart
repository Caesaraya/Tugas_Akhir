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

  final Rxn<File> selectedImage = Rxn<File>();
  final picker = ImagePicker();

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final RxBool showDeletedProducts = false.obs;
  final RxBool filterStockHabis = false.obs;

  @override
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      List<Product> products = await ApiService.getProducts();
      if (products != null) {
        setData(products);
        _applyFilters();
      } else {
        setData(<Product>[]);
      }
    } catch (e) {
      Get.snackbar(
        "Koneksi Bermasalah",
        "Gagal memuat data produk dari server.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade900,
        colorText: Colors.white,
      );
      setData(<Product>[]);
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilters() {
    String query = searchC.text.toLowerCase();

    List<Product> result = originalList.where((product) {
      bool matchesSearch =
          product.name.toLowerCase().contains(query) ||
          product.jenis.toLowerCase().contains(query) ||
          product.barcode.contains(query);

      bool isDeleted = product.deletedAt != null;
      bool matchesDeleteFilter = showDeletedProducts.value ? true : !isDeleted;
      bool matchesStockFilter = filterStockHabis.value
          ? product.stock == 0
          : true;

      return matchesSearch && matchesDeleteFilter && matchesStockFilter;
    }).toList();

    filteredList.assignAll(result);
    setupPagination();
  }

  void search(String query) {
    _applyFilters();
  }

  void toggleFilterStockHabis() {
    filterStockHabis.value = !filterStockHabis.value;
    _applyFilters();
  }

  void toggleShowDeletedProducts() {
    showDeletedProducts.value = !showDeletedProducts.value;
    _applyFilters();
  }

  void refreshData() {
    fetchData();
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void generateBarcode() {
    var random = Random();
    String code = "899";
    for (var i = 0; i < 10; i++) {
      code += random.nextInt(10).toString();
    }
    barcodeC.text = code;
  }

  void clearForm() {
    nameC.clear();
    priceC.clear();
    discountC.clear();
    stockC.clear();
    jenisC.clear();
    satuanC.clear();
    barcodeC.clear();
    selectedImage.value = null;
  }

  Future<void> insertProduct() async {
    if (nameC.text.isEmpty ||
        priceC.text.isEmpty ||
        stockC.text.isEmpty ||
        jenisC.text.isEmpty ||
        satuanC.text.isEmpty ||
        barcodeC.text.isEmpty ||
        selectedImage.value == null) {
      Get.snackbar(
        "Validasi",
        "Semua data termasuk gambar wajib diisi",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      int priceValue = int.parse(priceC.text.replaceAll(RegExp(r'[^0-9]'), ''));
      int discountValue = int.tryParse(discountC.text) ?? 0;
      int stockValue = int.parse(stockC.text);

      bool success = await ApiService.createProductWithImage(
        name: nameC.text,
        price: priceValue,
        discount: discountValue,
        stock: stockValue,
        jenis: jenisC.text,
        satuan: satuanC.text,
        barcode: barcodeC.text,
        imageFile: selectedImage.value!,
      );

      if (success) {
        Get.back();
        clearForm();
        Get.snackbar(
          "Berhasil",
          "Produk berhasil ditambahkan",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchData();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void openEditDialog(Product product) {
    nameC.text = product.name;
    priceC.text = currencyFormatter.format(product.price);
    discountC.text = product.discount.toString();
    stockC.text = product.stock.toString();
    jenisC.text = product.jenis;
    satuanC.text = product.satuan;
    barcodeC.text = product.barcode;
    selectedImage.value = null;

    Get.dialog(EditProductDialog(product: product));
  }

  Future<void> updateProduct(int id) async {
    if (nameC.text.isEmpty ||
        priceC.text.isEmpty ||
        stockC.text.isEmpty ||
        jenisC.text.isEmpty ||
        satuanC.text.isEmpty) {
      Get.snackbar(
        "Validasi",
        "Kolom utama tidak boleh kosong",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      int priceValue = int.parse(priceC.text.replaceAll(RegExp(r'[^0-9]'), ''));
      int discountValue = int.tryParse(discountC.text) ?? 0;
      int stockValue = int.parse(stockC.text);

      bool success = await ApiService.updateProductWithImage(
        id: id,
        name: nameC.text,
        price: priceValue,
        discount: discountValue,
        stock: stockValue,
        jenis: jenisC.text,
        satuan: satuanC.text,
        barcode: barcodeC.text,
        imageFile: selectedImage.value,
      );

      if (success) {
        Get.back();
        clearForm();
        Get.snackbar(
          "Berhasil",
          "Produk berhasil diperbarui",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchData();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void confirmSoftDelete(int id) {
    Get.defaultDialog(
      title: "Arsipkan Produk",
      middleText:
          "Apakah Anda yakin ingin memindahkan produk ini ke tempat sampah?",
      textConfirm: "Ya, Sampah",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.orange.shade700,
      onConfirm: () async {
        Get.back();
        try {
          bool success = await ApiService.softDeleteProduct(id);
          if (success) {
            Get.snackbar(
              "Berhasil",
              "Produk dipindahkan ke tempat sampah",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            fetchData();
          }
        } catch (e) {
          _showErrorSnackbar(e.toString());
        }
      },
    );
  }

  void confirmRestore(int id) {
    Get.defaultDialog(
      title: "Pulihkan Produk",
      middleText: "Apakah Anda yakin ingin mengaktifkan kembali produk ini?",
      textConfirm: "Ya, Aktifkan",
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
              "Produk berhasil diaktifkan kembali",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            fetchData();
          }
        } catch (e) {
          _showErrorSnackbar(e.toString());
        }
      },
    );
  }

  void confirmForceDelete(int id) {
    Get.defaultDialog(
      title: "Hapus Permanen",
      middleText:
          "Peringatan! Data yang dihapus secara permanen tidak dapat dikembalikan lagi.",
      textConfirm: "Ya, Hapus Total",
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
              "Produk telah dihapus secara permanen",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade900,
              colorText: Colors.white,
            );
            fetchData();
          }
        } catch (e) {
          _showErrorSnackbar(e.toString());
        }
      },
    );
  }

  void _showErrorSnackbar(String errorMsg) {
    Get.snackbar(
      "Error",
      "Gagal memproses aksi: $errorMsg",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void deleteData(int id) {
    confirmSoftDelete(id);
  }
}
