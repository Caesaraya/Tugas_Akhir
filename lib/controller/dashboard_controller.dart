// lib/controller/dashboard_controller.dart
//
// PERUBAHAN dari versi sebelumnya: fetchProducts() sekarang membaca dari
// ProductRepository (SQLite lokal) sebagai sumber utama -- selalu berhasil
// walau offline. Refresh dari server tetap dicoba di background supaya
// data lokal ikut ter-update, tapi kegagalannya tidak lagi membuat
// productList kosong seperti sebelumnya.

import 'dart:async';
import 'package:get/get.dart';
import 'package:tugas_akhir/data/repository/product_repository.dart';
import 'package:tugas_akhir/models/product.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var productList = <Product>[].obs;
  var filteredList = <Product>[].obs;

  var displayedList = <Product>[].obs;
  static const int _pageSize = 6;
  var currentPage = 1;

  var categories = <String>[].obs;
  var selectedCategory = 'Semua'.obs;
  var lastQuery = ''.obs;

  final ProductRepository _productRepository = ProductRepository.instance;

  bool get hasMore => displayedList.length < filteredList.length;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  /// Sekarang selalu baca dari SQLite dulu (cepat, jalan offline).
  /// Refresh dari server dijalankan di background dan tidak memblokir UI --
  /// kalau berhasil, kita baca ulang dari SQLite supaya UI ikut update.
  Future<void> fetchProducts() async {
    try {
      isLoading(true);

      final localProducts = await _productRepository.getLocalProducts();
      _applyToState(localProducts);

      // Refresh di background. Tidak di-await secara blocking terhadap
      // isLoading supaya UI tidak menggantung menunggu network.
      unawaited(_refreshInBackground());
    } catch (e) {
      print('Error Fetch Dashboard: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _refreshInBackground() async {
    await _productRepository.refreshFromServer();
    final refreshed = await _productRepository.getLocalProducts();
    _applyToState(refreshed);
  }

  void _applyToState(List<Product> products) {
    List<Product> updatedProducts = [];

    for (var product in products) {
      double originalPrice = product.price.toDouble();
      int discountPercent = product.discount;

      int calculatedPriceAfterDiscount = (discountPercent > 0)
          ? (originalPrice - (originalPrice * (discountPercent / 100))).round()
          : product.price;

      updatedProducts.add(
        product.copyWith(
          discount: discountPercent,
          priceAfterDiscount: calculatedPriceAfterDiscount,
        ),
      );
    }

    productList.assignAll(updatedProducts);

    var uniqueCategories = productList.map((p) => p.jenis).toSet().toList();
    uniqueCategories.sort();
    categories.assignAll(['Semua', ...uniqueCategories]);

    applyFilter();
  }

  void applyFilter({String? query, String? category}) {
    if (query != null) lastQuery.value = query;
    if (category != null) selectedCategory.value = category;

    var temp = productList.where((product) {
      bool isAvailable = product.stock > 0;
      bool matchCategory =
          selectedCategory.value == 'Semua' ||
          product.jenis == selectedCategory.value;
      bool matchSearch = product.name.toLowerCase().contains(
        lastQuery.value.toLowerCase(),
      );

      return matchCategory && matchSearch && isAvailable;
    }).toList();

    filteredList.assignAll(temp);

    currentPage = 1;
    displayedList.assignAll(filteredList.take(_pageSize).toList());
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) return;

    isLoadingMore(true);

    await Future.delayed(const Duration(milliseconds: 400));

    currentPage++;
    final nextItems = filteredList
        .skip(displayedList.length)
        .take(_pageSize)
        .toList();

    displayedList.addAll(nextItems);
    isLoadingMore(false);
  }

  double getFinalPrice(Product product) =>
      product.priceAfterDiscount.toDouble();
}
