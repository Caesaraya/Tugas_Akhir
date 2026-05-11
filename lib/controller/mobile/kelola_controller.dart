import 'package:get/get.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KelolaProdukController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = false.obs;
  var searchQuery = "".obs;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final discountPercentController = TextEditingController();
  final stockController = TextEditingController();
  final jenisController = TextEditingController();
  final satuanController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchData();
    debounce(
      searchQuery,
      (_) => runFilter(),
      time: const Duration(milliseconds: 500),
    );
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      final data = await ApiService.getProducts();
      products.assignAll(data);
      filteredProducts.assignAll(data);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat produk: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    discountPercentController.dispose();
    stockController.dispose();
    jenisController.dispose();
    satuanController.dispose();
    super.onClose();
  }

  void showEditForm(BuildContext context, Product product) {
    nameController.text = product.name;

    // 1. Format harga ke Rupiah saat pertama kali form dibuka
    priceController.text = currencyFormatter.format(product.price);

    discountPercentController.text = product.discount.toString();
    stockController.text = product.stock.toString();
    jenisController.text = product.jenis;
    satuanController.text = product.satuan;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Edit Produk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, "Nama Produk"),
              const SizedBox(height: 12),
              // Gunakan isPrice: true agar formatter berjalan
              _buildTextField(
                priceController,
                "Harga",
                isNumber: true,
                isPrice: true,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                discountPercentController,
                "Diskon (%)",
                isNumber: true,
              ),
              const SizedBox(height: 12),
              _buildTextField(stockController, "Stok", isNumber: true),
              const SizedBox(height: 12),
              _buildTextField(jenisController, "Jenis"),
              const SizedBox(height: 12),
              _buildTextField(satuanController, "Satuan"),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () => _updateProduct(product.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE89336),
            ),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    bool isPrice = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      onChanged: (value) {
        if (isPrice && value.isNotEmpty) {
          // 1. Bersihkan input dari karakter non-digit
          String cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
          if (cleanValue.isEmpty) cleanValue = "0";

          // 2. Format ulang ke mata uang
          String formatted = currencyFormatter.format(int.parse(cleanValue));

          // 3. HANYA update jika teks berbeda (mencegah loop/error keyboard)
          if (controller.text != formatted) {
            controller.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          }
        }
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _updateProduct(int id) async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar(
        "Validasi",
        "Nama dan Harga tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // 1. AMBIL ANGKA MURNI TERLEBIH DAHULU
      // Ini menghapus "Rp", ".", dan spasi agar menjadi "52500"
      String cleanPriceText = priceController.text.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );

      // 2. CEK APAKAH HASILNYA KOSONG ATAU TIDAK
      if (cleanPriceText.isEmpty) cleanPriceText = "0";

      int numericPrice = int.parse(cleanPriceText);

      // 3. HITUNG DISKON MENGGUNAKAN HARGA YANG SUDAH BERSIH
      // Ambil diskon, jika kosong set ke 0
      String cleanDiscountText = discountPercentController.text.isEmpty
          ? "0"
          : discountPercentController.text;
      double percent = double.tryParse(cleanDiscountText) ?? 0;

      final double finalDiscountAmount = (percent / 100) * numericPrice;

      Get.back(); // Tutup dialog
      isLoading(true);

      final updatedProduct = Product(
        id: id,
        name: nameController.text,
        price: numericPrice, // Kirim angka murni
        discount: finalDiscountAmount.toInt(),
        stock: int.tryParse(stockController.text) ?? 0,
        jenis: jenisController.text,
        satuan: satuanController.text,
        barcode: "",
        image: "",
      );

      final success = await ApiService.updateProduct(updatedProduct);

      if (success) {
        Get.snackbar(
          "Sukses",
          "Produk berhasil diperbarui",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchData();
      } else {
        Get.snackbar(
          "Gagal",
          "Gagal memperbarui produk",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Detail Error: $e"); // Muncul di console debug
      Get.snackbar(
        "Error",
        "Format angka salah: Pastikan input hanya angka",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void runFilter() {
    if (searchQuery.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      var result = products
          .where(
            (p) =>
                p.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
      filteredProducts.assignAll(result);
    }
  }

  void refreshData() => fetchData();
}
