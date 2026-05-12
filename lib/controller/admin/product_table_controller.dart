import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../api service/api_service.dart';
import '../../models/product.dart';
import '../../controller/admin/table/base_table_controller.dart';

class ProductTableController extends BaseTableController<Product> {
  ProductTableController() {
    itemsPerPage = 35;
  }

  final nameC = TextEditingController();
  final priceC = TextEditingController();
  final discountC = TextEditingController();
  final stockC = TextEditingController();
  final jenisC = TextEditingController();
  final satuanC = TextEditingController();

  final Rx<File?> selectedImage = Rx<File?>(null);

  final picker = ImagePicker();

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
      filteredList.assignAll(
        originalList.where((product) {
          final searchText = query.toLowerCase();

          return product.name.toLowerCase().contains(searchText) ||
              product.barcode.toLowerCase().contains(searchText) ||
              product.jenis.toLowerCase().contains(searchText) ||
              product.satuan.toLowerCase().contains(searchText) ||
              product.price.toString().contains(searchText) ||
              product.stock.toString().contains(searchText) ||
              product.discount.toString().contains(searchText);
        }).toList(),
      );
    }

    currentPage.value = 1;

    setupPagination();
  }

  void sortStockHabis() {
    filteredList.assignAll(originalList.where((e) => e.stock <= 0).toList());

    setupPagination();
  }

  Future<void> pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
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
        price: int.parse(priceC.text),
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

  Future<void> deleteData(int id) async {
    await ApiService.deleteProduct(id);

    fetchData();
  }
}
