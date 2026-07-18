import 'dart:async';
import 'package:get/get.dart';
import 'package:tugas_akhir/data/repository/product_repository.dart';
import 'package:tugas_akhir/models/product.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var productList = <Product>[].obs;
  var filteredList = <Product>[].obs;
  var sortOption = 'none'.obs;

  var displayedList = <Product>[].obs;
  static const int _pageSize = 6;
  var currentPage = 1;

  var categories = <String>[].obs;
  var selectedCategory = 'Semua'.obs;
  var lastQuery = ''.obs;

  final ProductRepository productRepository = ProductRepository.instance;

  bool get hasMore => displayedList.length < filteredList.length;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);

      final localProducts = await productRepository.getLocalProducts();
      applyToState(localProducts);
      unawaited(refreshInBackground());
    } catch (e) {
      print('Error Fetch Dashboard: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshInBackground() async {
    await productRepository.refreshFromServer();
    final refreshed = await productRepository.getLocalProducts();
    applyToState(refreshed);
  }

  void applyToState(List<Product> products) {
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

  void applyFilter({String? query, String? category, String? sort}) {
    if (query != null) lastQuery.value = query;
    if (category != null) selectedCategory.value = category;
    if (sort != null) sortOption.value = sort;

    var temp = productList.where((product) {
      bool matchCategory =
          selectedCategory.value == 'Semua' ||
          product.jenis == selectedCategory.value;
      bool matchSearch = product.name.toLowerCase().contains(
        lastQuery.value.toLowerCase(),
      );
      return matchCategory && matchSearch;
    }).toList();
    final indexed = temp.asMap().entries.toList();

    indexed.sort((a, b) {
      final productA = a.value;
      final productB = b.value;
      if (productA.stock > 0 && productB.stock <= 0) return -1;
      if (productA.stock <= 0 && productB.stock > 0) return 1;

      switch (sortOption.value) {
        case 'low_to_high':
          return productA.priceAfterDiscount.compareTo(
            productB.priceAfterDiscount,
          );
        case 'high_to_low':
          return productB.priceAfterDiscount.compareTo(
            productA.priceAfterDiscount,
          );
        default:
          return a.key.compareTo(b.key);
      }
    });

    filteredList.assignAll(indexed.map((e) => e.value).toList());
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