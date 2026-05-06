import 'package:get/get.dart';
import 'package:tugas_akhir/api service/api_service.dart';
import 'package:tugas_akhir/models/product.dart';

class ProductController extends GetxController {
  // Observable state
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
    } catch (_) {
      // Fallback dummy data bila API gagal
      loadDummyProducts();
    } finally {
      isLoading(false);
    }
  }

  void loadDummyProducts() {
    products.assignAll([
      Product(
        id: 1,
        name: 'Roti Pizza',
        price: 15000,
        discount: 0,
        stock: 20,
        jenis: 'Roti',
        satuan: 'pcs',
        barcode: '1234567890123',
        image: '',
      ),
      Product(
        id: 2,
        name: 'Mini Pizza',
        price: 12000,
        discount: 20,
        stock: 0,
        jenis: 'Roti',
        satuan: 'pcs',
        barcode: '1234567890124',
        image: '',
      ),
      Product(
        id: 3,
        name: 'Roti Sosis',
        price: 14000,
        discount: 0,
        stock: 0,
        jenis: 'Roti',
        satuan: 'pcs',
        barcode: '1234567890125',
        image: '',
      ),
      Product(
        id: 4,
        name: 'Nama Produk',
        price: 10000,
        discount: 10,
        stock: 0,
        jenis: 'Roti',
        satuan: 'pcs',
        barcode: '1234567890126',
        image: '',
      ),
    ]);
  }

  // Computed property for filtered products
  List<Product> get filteredProducts {
    var result = products.toList();

    // Apply out of stock filter
    if (isFilteringOutOfStock.value) {
      result = result.where((p) => p.stock == 0).toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where(
            (p) =>
                p.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
    }

    return result;
  }

  int get totalFilteredCount => filteredProducts.length;

  int get totalPages =>
      (totalFilteredCount / pageSize).ceil().clamp(1, double.infinity).toInt();

  List<Product> get paginatedProducts {
    final start = (currentPage.value - 1) * pageSize;
    final end = (start + pageSize).clamp(0, filteredProducts.length);
    return filteredProducts.sublist(start, end);
  }

  // Methods
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
  }

  void filterOutOfStock() {
    isFilteringOutOfStock.toggle();
    currentPage.value = 1;
  }

  void resetProducts() {
    fetchProducts();
    searchQuery.value = '';
    isFilteringOutOfStock.value = false;
    currentPage.value = 1;
  }

  void nextPage() {
    if (currentPage.value < totalPages) {
      currentPage.value += 1;
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value -= 1;
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      currentPage.value = page;
    }
  }

  void addProduct(Product product) {
    products.add(product);
  }

  void removeProduct(int id) {
    products.removeWhere((p) => p.id == id);
  }

  void updateProduct(int id, Product updatedProduct) {
    final index = products.indexWhere((p) => p.id == id);
    if (index != -1) {
      products[index] = updatedProduct;
    }
  }

  void setEditingProduct(Product product) {
    editingProduct.value = product;
  }

  Future<void> saveProductChanges(Product updatedProduct) async {
    try {
      isLoading(true);
      // Simpan ke API
      final success = await ApiService.updateProduct(updatedProduct);

      if (success) {
        // Update data lokal jika API berhasil
        updateProduct(updatedProduct.id, updatedProduct);
        editingProduct.value = null;
        // TODO: Show success message
      } else {
        // TODO: Show error message
      }
    } catch (e) {
      // TODO: Show error message
      print('Error updating product: $e');
    } finally {
      isLoading(false);
    }
  }

  void clearEditingProduct() {
    editingProduct.value = null;
  }
}
