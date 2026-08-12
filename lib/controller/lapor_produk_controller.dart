import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/api service/api_service.dart';
import 'package:tugas_akhir/models/product.dart';

class LaporProdukController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var searchQuery = "".obs;
  var currentPage = 1.obs;
  static const int pageSize = 15;

  List<Product> get paginatedProducts {
    if (filteredProducts.isEmpty) return [];

    final start = (currentPage.value - 1) * pageSize;

    if (start >= filteredProducts.length) {
      currentPage.value = totalPages;
      return [];
    }

    final end = (start + pageSize).clamp(0, filteredProducts.length);

    return filteredProducts.sublist(start, end);
  }

  int get totalPages {
    if (filteredProducts.isEmpty) return 1;
    return (filteredProducts.length / pageSize).ceil();
  }

  void nextPage() {
    if (currentPage.value < totalPages) {
      currentPage.value++;
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      currentPage.value = page;
    }
  }

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // --------- Form lapor ---------
  final jumlahController = TextEditingController();
  final alasanController = TextEditingController();

  final listKategori = const ['Rusak', 'Kadaluwarsa'];
  final selectedKategori = 'Rusak'.obs;
  final selectedTanggal = DateTime.now().obs;

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
      if (searchQuery.value.isEmpty) {
        filteredProducts.assignAll(products);
      } else {
        filteredProducts.assignAll(
          products
              .where(
                (p) => p.name.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
              )
              .toList(),
        );
      }
      if (currentPage.value > totalPages) {
        currentPage.value = totalPages;
      }
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

  void runFilter() {
    if (searchQuery.value.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products
            .where(
              (p) => p.name.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ),
            )
            .toList(),
      );
    }
    currentPage.value = 1;
  }

  void refreshData() => fetchData();

  @override
  void onClose() {
    jumlahController.dispose();
    alasanController.dispose();
    super.onClose();
  }

  void showLaporForm(BuildContext context, Product product) {
    jumlahController.clear();
    alasanController.clear();
    selectedKategori.value = 'Rusak';
    selectedTanggal.value = DateTime.now();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Lapor Produk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                "Stock saat ini: ${product.stock}",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 16),

              // Jumlah rusak/kadaluwarsa
              TextField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: "Jumlah",
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Kategori
              Obx(
                () => DropdownButtonFormField<String>(
                  value: selectedKategori.value,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: listKategori
                      .map(
                        (k) => DropdownMenuItem(value: k, child: Text(k)),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) selectedKategori.value = val;
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Tanggal kejadian
              Obx(
                () => InkWell(
                  onTap: () => pickTanggal(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Tanggal Kejadian',
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      DateFormat('dd MMM yyyy').format(selectedTanggal.value),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Alasan
              TextField(
                controller: alasanController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Alasan",
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          Obx(
            () => ElevatedButton(
              onPressed: isSubmitting.value ? null : () => submitLapor(product),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE89336),
              ),
              child: isSubmitting.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Kirim", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> pickTanggal(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggal.value,
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now(),
    );
    if (picked != null) selectedTanggal.value = picked;
  }

  Future<void> submitLapor(Product product) async {
    final jumlah = int.tryParse(jumlahController.text) ?? 0;

    if (jumlah <= 0) {
      Get.snackbar(
        "Validasi",
        "Jumlah harus lebih dari 0",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (jumlah > product.stock) {
      Get.snackbar(
        "Validasi",
        "Jumlah melebihi stock saat ini (${product.stock})",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (alasanController.text.trim().isEmpty) {
      Get.snackbar(
        "Validasi",
        "Alasan tidak boleh kosong",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final newStock = product.stock - jumlah;
    final tanggalFormatted = DateFormat('dd MMM yyyy').format(
      selectedTanggal.value,
    );
    // Kategori & tanggal digabung ke reason karena model/endpoint yang ada
    // hanya punya satu field "reason".
    final reasonText =
        "[${selectedKategori.value}] $tanggalFormatted - ${alasanController.text.trim()}";

    try {
      Get.back();
      isSubmitting(true);

      final success = await ApiService.createStockAdjustmentRequest(
        productId: product.id,
        oldStock: product.stock,
        newStock: newStock,
        reason: reasonText,
      );

      if (success) {
        Get.snackbar(
          "Terkirim",
          "Laporan berhasil dikirim, menunggu persetujuan admin",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchData();
      } else {
        Get.snackbar(
          "Gagal",
          "Gagal mengirim laporan",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengirim laporan: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting(false);
    }
  }
}