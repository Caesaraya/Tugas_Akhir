import 'package:get/get.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';
import 'package:tugas_akhir/models/diskon.dart';
import 'package:tugas_akhir/models/product.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var filteredList = <Product>[].obs;

  // Tambahkan state untuk kategori
  var categories = <String>[].obs;
  var selectedCategory = "Semua".obs;
  var lastQuery = "".obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);

      // Ambil produk dan diskon secara bersamaan
      final results = await Future.wait([
        ApiService.getProducts(),
        ApiService.getAllDiskon(),
      ]);

      var products = results[0] as List<Product>?;
      var discounts = results[1] as List<Diskon>?;

      if (products != null) {
        if (discounts != null) {
          for (var product in products) {
            var activeDisc = discounts.firstWhereOrNull(
              (d) => d.status.toUpperCase() == 'AKTIF' && d.isActive,
            );

            if (activeDisc != null) {
              product.discount = activeDisc.persenDiskon.toInt();
            }
          }
        }

        productList.assignAll(products);
        var uniqueCategories = productList.map((p) => p.jenis).toSet().toList();
        uniqueCategories.sort();
        categories.assignAll(["Semua", ...uniqueCategories]);
        applyFilter();
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // Helper untuk hitung harga akhir di UI
  double getFinalPrice(Product product) {
    double price = product.price?.toDouble() ?? 0;
    double discPercent = product.discount?.toDouble() ?? 0;
    return price - (price * (discPercent / 100));
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
}
