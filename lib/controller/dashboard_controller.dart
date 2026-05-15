import 'package:get/get.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';
import 'package:tugas_akhir/models/product.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var productList = <Product>[].obs;
  var filteredList = <Product>[].obs;

  // ─── Pagination ───────────────────────────────────────────────────────────
  var displayedList = <Product>[].obs;
  static const int _pageSize = 6;
  var _currentPage = 1;

  var categories = <String>[].obs;
  var selectedCategory = 'Semua'.obs;
  var lastQuery = ''.obs;

  // ─── Apakah masih ada produk yang belum dimuat ────────────────────────────
  bool get hasMore => displayedList.length < filteredList.length;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  // ─── Fetch dari API ───────────────────────────────────────────────────────
  Future<void> fetchProducts() async {
    try {
      isLoading(true);

      final products = await ApiService.getProducts();

      if (products != null) {
        List<Product> updatedProducts = [];

        for (var product in products) {
          double originalPrice = product.price.toDouble();
          int discountPercent = product.discount ?? 0;

          int calculatedPriceAfterDiscount = (discountPercent > 0)
              ? (originalPrice - (originalPrice * (discountPercent / 100)))
                    .round()
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
    } catch (e) {
      print('Error Fetch Dashboard: $e');
    } finally {
      isLoading(false);
    }
  }

  // ─── Filter + reset pagination ────────────────────────────────────────────
  void applyFilter({String? query, String? category}) {
    if (query != null) lastQuery.value = query;
    if (category != null) selectedCategory.value = category;

    var temp = productList.where((product) {
      bool isAvailable = product.stock > 0;
      bool matchCategory =
          selectedCategory.value == 'Semua' ||
          product.jenis == selectedCategory.value;
      bool matchSearch =
          product.name.toLowerCase().contains(lastQuery.value.toLowerCase()) ||
          product.barcode.contains(lastQuery.value);

      return matchCategory && matchSearch && isAvailable;
    }).toList();

    filteredList.assignAll(temp);

    // Reset pagination setiap kali filter berubah
    _currentPage = 1;
    displayedList.assignAll(filteredList.take(_pageSize).toList());
  }

  // ─── Muat 6 produk berikutnya ─────────────────────────────────────────────
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) return;

    isLoadingMore(true);

    // Delay kecil agar loading indicator sempat tampil
    await Future.delayed(const Duration(milliseconds: 400));

    _currentPage++;
    final nextItems = filteredList
        .skip(displayedList.length)
        .take(_pageSize)
        .toList();

    displayedList.addAll(nextItems);
    isLoadingMore(false);
  }

  // ─── Helper harga akhir ───────────────────────────────────────────────────
  double getFinalPrice(Product product) =>
      product.priceAfterDiscount.toDouble();
}
