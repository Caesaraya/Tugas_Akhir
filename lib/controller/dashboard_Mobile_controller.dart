import 'package:get/get.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var filteredList = <Product>[].obs;

  // Tambahkan state untuk kategori
  var categories = <String>[].obs;
  var selectedCategory = "Semua".obs;
  var lastQuery = "".obs;
  var errorMessage = "".obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      errorMessage.value = "";
      var products = await ApiService.getProducts();
      if (products.isNotEmpty) {
        productList.assignAll(products);
        // Extract unique jenis from products
        var uniqueCategories = productList.map((p) => p.jenis).toSet().toList();
        uniqueCategories.sort();
        categories.assignAll(["Semua", ...uniqueCategories]);
        applyFilter();
      }
    } catch (e) {
      errorMessage.value = "Gagal memuat produk: $e";
      Get.snackbar("Error", errorMessage.value, 
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Fungsi tunggal untuk menangani pencarian DAN kategori sekaligus
  void applyFilter({String? query, String? category}) {
    // Update state jika ada parameter yang dikirim
    if (query != null) lastQuery.value = query;
    if (category != null) selectedCategory.value = category;

    var temp = productList.where((product) {
      // Cek apakah produk sesuai dengan kategori yang dipilih
      bool matchCategory =
          selectedCategory.value == "Semua" ||
          product.jenis == selectedCategory.value;

      // Cek apakah produk sesuai dengan kata kunci pencarian (nama atau barcode)
      bool matchSearch =
          product.name.toLowerCase().contains(lastQuery.value.toLowerCase()) ||
          product.barcode.contains(lastQuery.value);

      return matchCategory && matchSearch;
    }).toList();

    filteredList.assignAll(temp);
  }

  void resetFilters() {
    selectedCategory.value = "Semua";
    lastQuery.value = "";
    applyFilter();
  }
}
