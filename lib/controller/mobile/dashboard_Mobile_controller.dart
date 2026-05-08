import 'package:get/get.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';
import 'package:tugas_akhir/models/diskon.dart';
import 'package:tugas_akhir/models/product.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var filteredList = <Product>[].obs;

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

    // Langsung ambil data produk (asumsinya API produk sudah membawa info diskon)
    final products = await ApiService.getProducts();

    if (products != null) {
      List<Product> updatedProducts = [];

      for (var product in products) {
        // Ambil nilai diskon langsung dari field 'discount' milik produk
        double originalPrice = product.price.toDouble();
        int discountPercent = product.discount ?? 0;

        // Hitung harga setelah diskon secara otomatis
        int calculatedPriceAfterDiscount = (discountPercent > 0)
            ? (originalPrice - (originalPrice * (discountPercent / 100))).round()
            : product.price;

        updatedProducts.add(product.copyWith(
          discount: discountPercent,
          priceAfterDiscount: calculatedPriceAfterDiscount,
        ));
      }

      productList.assignAll(updatedProducts);
      
      // Update kategori
      var uniqueCategories = productList.map((p) => p.jenis).toSet().toList();
      uniqueCategories.sort();
      categories.assignAll(["Semua", ...uniqueCategories]);
      
      applyFilter();
    }
  } catch (e) {
    print("Error Fetch Dashboard: $e");
  } finally {
    isLoading(false);
  }
}

  // HELPER: Mengambil harga akhir
  // Karena sekarang sudah ada field priceAfterDiscount di model, 
  // kita tinggal mengambil nilainya saja.
  double getFinalPrice(Product product) {
    return product.priceAfterDiscount.toDouble();
  }

  void applyFilter({String? query, String? category}) {
    if (query != null) lastQuery.value = query;
    if (category != null) selectedCategory.value = category;

    var temp = productList.where((product) {
      bool matchCategory =
          selectedCategory.value == "Semua" ||
          product.jenis == selectedCategory.value;

      bool matchSearch =
          product.name.toLowerCase().contains(lastQuery.value.toLowerCase()) ||
          product.barcode.contains(lastQuery.value);

      return matchCategory && matchSearch;
    }).toList();

    filteredList.assignAll(temp);
  }
}