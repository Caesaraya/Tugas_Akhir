import 'package:get/get.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';
import 'package:tugas_akhir/models/product.dart';


class DashboardController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var selectedIndex = 0.obs;
  var filteredList = <Product>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await ApiService.getProducts();
      if (products != null) {
        productList.assignAll(products);
        filteredList.assignAll(products);
      }
    } finally {
      isLoading(false);
    }
  }
  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(productList); // Jika kosong, tampilkan semua
    } else {
      var result = productList.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filteredList.assignAll(result);
    }
  }
}