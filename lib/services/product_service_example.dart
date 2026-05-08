import 'package:tugas_akhir/api service/api_service.dart';
import 'package:tugas_akhir/models/product.dart';

/// Contoh implementasi service untuk Products
/// Ini adalah bagaimana cara menggunakan API Products dengan model yang sudah ada
class ProductServiceExample {
  
  /// Mengambil semua produk
  static Future<List<Product>> getAllProducts() async {
    try {
      return await ApiService.getProducts();
    } catch (e) {
      throw Exception('Gagal mengambil data produk: $e');
    }
  }

  /// Mengambil produk berdasarkan ID
  static Future<Product> getProductById(int id) async {
    try {
      return await ApiService.getProductById(id);
    } catch (e) {
      throw Exception('Gagal mengambil produk dengan ID $id: $e');
    }
  }

  /// Membuat produk baru
  static Future<bool> createProduct({
    required String name,
    required int price,
    required int stock,
    required String jenis,
    required String satuan,
    required String barcode,
    required String image,
    int discount = 0,
    int? resepId,
  }) async {
    try {
      // Buat produk baru dengan priceAfterDiscount dihitung otomatis
      final newProduct = Product(
        id: 0, // ID akan di-generate oleh backend
        name: name,
        price: price,
        discount: discount,
        priceAfterDiscount: price - (price * discount ~/ 100), // Hitung harga setelah diskon
        stock: stock,
        jenis: jenis,
        satuan: satuan,
        barcode: barcode,
        image: image,
        resepId: resepId,
      );

      return await ApiService.createProduct(newProduct);
    } catch (e) {
      throw Exception('Gagal membuat produk: $e');
    }
  }

  /// Update produk yang sudah ada
  static Future<bool> updateProduct(Product product) async {
    try {
      // Pastikan priceAfterDiscount selalu dihitung ulang saat update
      final updatedProduct = Product(
        id: product.id,
        name: product.name,
        price: product.price,
        discount: product.discount,
        priceAfterDiscount: product.price - (product.price * product.discount ~/ 100),
        stock: product.stock,
        jenis: product.jenis,
        satuan: product.satuan,
        barcode: product.barcode,
        image: product.image,
        resepId: product.resepId,
      );

      return await ApiService.updateProduct(updatedProduct);
    } catch (e) {
      throw Exception('Gagal update produk: $e');
    }
  }

  /// Hapus produk berdasarkan ID
  static Future<bool> deleteProduct(int id) async {
    try {
      return await ApiService.deleteProduct(id);
    } catch (e) {
      throw Exception('Gagal hapus produk: $e');
    }
  }

  /// Contoh penggunaan dengan error handling
  static Future<void> exampleUsage() async {
    try {
      // 1. Ambil semua produk
      print('Mengambil semua produk...');
      final products = await getAllProducts();
      print('Berhasil mengambil ${products.length} produk');

      // 2. Ambil produk pertama
      if (products.isNotEmpty) {
        final firstProduct = products.first;
        print('Produk pertama: ${firstProduct.name} - Harga: ${firstProduct.priceAfterDiscount}');

        // 3. Update produk
        print('Mengupdate produk...');
        await updateProduct(firstProduct);
        print('Produk berhasil diupdate');
      }

      // 4. Buat produk baru
      print('Membuat produk baru...');
      await createProduct(
        name: 'Roti Bakar',
        price: 15000,
        stock: 50,
        jenis: 'BREAD',
        satuan: 'pcs',
        barcode: '123456789',
        image: 'bread.jpg',
        discount: 10,
      );
      print('Produk baru berhasil dibuat');

    } catch (e) {
      print('Error: $e');
    }
  }
}
