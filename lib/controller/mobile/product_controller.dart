import 'package:get/get.dart';
import 'package:tugas_akhir/api service/api_service.dart';
import 'package:tugas_akhir/models/product.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var searchQuery = ''.obs;
  var currentPage = 1.obs;
  var isFilteringOutOfStock = false.obs;
  var editingProduct = Rx<Product?>(null);
  final int pageSize = 35;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final fetched = await ApiService.getProducts();
      products.assignAll(fetched);
    } catch (e) {
      print("Error fetch products: $e");
      // Fallback ke dummy data jika API gagal
     
    } finally {
      isLoading(false);
    }
  }

  // --- LOGIC FILTER ---
  List<Product> get filteredProducts {
    // Gunakan .where secara beruntun agar lebih efisien
    return products.where((p) {
      // Filter Stok Habis
      bool matchStock = isFilteringOutOfStock.value ? p.stock == 0 : true;
      
      // Filter Pencarian (Nama atau Barcode)
      bool matchSearch = searchQuery.value.isEmpty || 
          p.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          p.barcode.contains(searchQuery.value);

      return matchStock && matchSearch;
    }).toList();
  }

  // --- PAGINATION ---
  int get totalFilteredCount => filteredProducts.length;

  int get totalPages => (totalFilteredCount / pageSize).ceil().clamp(1, 999);

  List<Product> get paginatedProducts {
    final start = (currentPage.value - 1) * pageSize;
    if (start >= filteredProducts.length) return [];
    
    final end = (start + pageSize).clamp(0, filteredProducts.length);
    return filteredProducts.sublist(start, end);
  }

  // --- ACTIONS ---
  void updateProductLocally(int id, Product updatedProduct) {
    final index = products.indexWhere((p) => p.id == id);
    if (index != -1) {
      products[index] = updatedProduct;
      products.refresh(); // PENTING: Memastikan GetX menyadari perubahan isi list
    }
  }

  Future<void> saveProductChanges(Product updatedProduct) async {
    try {
      isLoading(true);
      final success = await ApiService.updateProduct(updatedProduct);

      if (success) {
        updateProductLocally(updatedProduct.id, updatedProduct);
        editingProduct.value = null;
        Get.snackbar("Sukses", "Produk berhasil diperbarui", 
          snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Gagal", "Gagal memperbarui produk di server");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading(false);
    }
  }
  
  // Tambahan: Helper untuk cek apakah produk punya resep
  bool hasRecipe(Product product) => product.resepId != null;

  // Method standar lainnya (updateSearchQuery, nextPage, dll) tetap sama
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
  }
  
  void filterOutOfStock() {
    isFilteringOutOfStock.toggle();
    currentPage.value = 1;
  }
}