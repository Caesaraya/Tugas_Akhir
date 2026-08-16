import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/api service/api_service.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/models/stock_adjustment_request.dart';

class LaporProdukController extends GetxController {
  // ================================================================
  // PRODUCT
  // ================================================================

  final products = <Product>[].obs;
  final filteredProducts = <Product>[].obs;

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  final searchQuery = ''.obs;
  final currentPage = 1.obs;

  static const int pageSize = 15;

  // ================================================================
  // RIWAYAT LAPORAN
  // ================================================================

  final stockAdjustmentRequests = <StockAdjustmentRequest>[].obs;

  final isLoadingHistory = false.obs;

  // ================================================================
  // PAGINATION PRODUCT
  // ================================================================

  List<Product> get paginatedProducts {
    if (filteredProducts.isEmpty) {
      return [];
    }

    final start = (currentPage.value - 1) * pageSize;

    if (start >= filteredProducts.length) {
      currentPage.value = totalPages;
      return [];
    }

    final end = (start + pageSize).clamp(0, filteredProducts.length);

    return filteredProducts.sublist(start, end);
  }

  int get totalPages {
    if (filteredProducts.isEmpty) {
      return 1;
    }

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

  // ================================================================
  // FORMATTER
  // ================================================================

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // ================================================================
  // FORM LAPOR
  // ================================================================

  final jumlahController = TextEditingController();
  final alasanController = TextEditingController();

  // Observable jumlah untuk preview stok
  final jumlahInput = 0.obs;

  // Jenis request
  final listJenisRequest = const ['Kurangi Stok', 'Tambah Stok'];

  final selectedJenisRequest = 'Kurangi Stok'.obs;

  // Kategori pengurangan
  final listKategoriKurang = const ['Rusak', 'Kadaluwarsa'];

  // Kategori penambahan
  final listKategoriTambah = const ['Restock', 'Koreksi Stok'];

  final selectedKategori = 'Rusak'.obs;

  final selectedTanggal = DateTime.now().obs;

  // ================================================================
  // INIT
  // ================================================================

  @override
  void onInit() {
    super.onInit();

    fetchData();
    fetchHistory();

    debounce(
      searchQuery,
      (_) => runFilter(),
      time: const Duration(milliseconds: 500),
    );
  }

  // ================================================================
  // FETCH PRODUCTS
  // ================================================================

  Future<void> fetchData() async {
    try {
      isLoading(true);

      final data = await ApiService.getProducts();

      products.assignAll(data);

      if (searchQuery.value.isEmpty) {
        filteredProducts.assignAll(products);
      } else {
        filteredProducts.assignAll(
          products.where(
            (p) =>
                p.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
          ),
        );
      }

      if (currentPage.value > totalPages) {
        currentPage.value = totalPages;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat produk: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // ================================================================
  // FILTER PRODUCT
  // ================================================================

  void runFilter() {
    if (searchQuery.value.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where(
          (p) => p.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        ),
      );
    }

    currentPage.value = 1;
  }

  void refreshData() {
    fetchData();
  }

  // ================================================================
  // FETCH RIWAYAT LAPORAN
  // ================================================================

  Future<void> fetchHistory() async {
    try {
      isLoadingHistory(true);

      final data = await ApiService.getMyStockAdjustmentRequests();

      stockAdjustmentRequests.assignAll(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat riwayat laporan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingHistory(false);
    }
  }

  // ================================================================
  // REFRESH RIWAYAT
  // ================================================================

  Future<void> refreshHistory() async {
    await fetchHistory();
  }

  // ================================================================
  // KATEGORI
  // ================================================================

  List<String> get kategoriList {
    if (selectedJenisRequest.value == 'Tambah Stok') {
      return listKategoriTambah;
    }

    return listKategoriKurang;
  }

  // ================================================================
  // GANTI JENIS REQUEST
  // ================================================================

  void changeJenisRequest(String value) {
    selectedJenisRequest.value = value;

    if (value == 'Tambah Stok') {
      selectedKategori.value = 'Restock';
    } else {
      selectedKategori.value = 'Rusak';
    }
  }

  // ================================================================
  // HITUNG STOCK BARU
  // ================================================================

  int calculateNewStock(Product product) {
    final jumlah = int.tryParse(jumlahController.text) ?? 0;

    if (selectedJenisRequest.value == 'Tambah Stok') {
      return product.stock + jumlah;
    }

    return product.stock - jumlah;
  }

  // ================================================================
  // STATUS
  // ================================================================

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Diterima';

      case 'rejected':
        return 'Ditolak';

      case 'pending':
      default:
        return 'Menunggu';
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      case 'pending':
      default:
        return Colors.orange;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;

      case 'rejected':
        return Icons.cancel;

      case 'pending':
      default:
        return Icons.access_time;
    }
  }

  // ================================================================
  // INFORMASI PERUBAHAN STOCK
  // ================================================================

  String getStockChangeText(StockAdjustmentRequest laporan) {
    switch (laporan.status.toLowerCase()) {
      case 'approved':
        if (laporan.newStock > laporan.oldStock) {
          return 'Laporan diterima. Stock berhasil '
              'ditambah dari ${laporan.oldStock} '
              'menjadi ${laporan.newStock}.';
        }

        if (laporan.newStock < laporan.oldStock) {
          return 'Laporan diterima. Stock berhasil '
              'dikurangi dari ${laporan.oldStock} '
              'menjadi ${laporan.newStock}.';
        }

        return 'Laporan diterima. Stock tidak mengalami perubahan.';

      case 'rejected':
        return 'Laporan ditolak oleh admin. '
            'Stock tidak diubah.';

      case 'pending':
      default:
        if (laporan.newStock > laporan.oldStock) {
          return 'Menunggu persetujuan admin. '
              'Stock belum ditambah.';
        }

        if (laporan.newStock < laporan.oldStock) {
          return 'Menunggu persetujuan admin. '
              'Stock belum dikurangi.';
        }

        return 'Menunggu persetujuan admin.';
    }
  }

  // ================================================================
  // FORM LAPOR
  // ================================================================

  void showLaporForm(BuildContext context, Product product) {
    jumlahController.clear();
    alasanController.clear();

    jumlahInput.value = 0;

    selectedJenisRequest.value = 'Kurangi Stok';

    selectedKategori.value = 'Rusak';

    selectedTanggal.value = DateTime.now();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Lapor Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // NAMA PRODUK
              // ==================================================
              Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 4),

              // TIDAK DIBUNGKUS OBX
              // karena product.stock bukan Rx
              Text(
                'Stock saat ini: ${product.stock}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // JENIS LAPORAN
              // ==================================================
              Obx(
                () => DropdownButtonFormField<String>(
                  value: selectedJenisRequest.value,

                  decoration: InputDecoration(
                    labelText: 'Jenis Laporan',
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

                  items: listJenisRequest
                      .map(
                        (jenis) => DropdownMenuItem(
                          value: jenis,
                          child: Row(
                            children: [
                              Icon(
                                jenis == 'Tambah Stok'
                                    ? Icons.add_circle_outline
                                    : Icons.remove_circle_outline,
                                size: 18,
                                color: jenis == 'Tambah Stok'
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                              const SizedBox(width: 8),
                              Text(jenis),
                            ],
                          ),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    if (value != null) {
                      changeJenisRequest(value);
                    }
                  },
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // JUMLAH
              // ==================================================
              TextField(
                controller: jumlahController,

                keyboardType: TextInputType.number,

                inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                onChanged: (value) {
                  jumlahInput.value = int.tryParse(value) ?? 0;
                },

                decoration: InputDecoration(
                  labelText: 'Jumlah',
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ==================================================
              // PREVIEW STOCK
              // ==================================================
              Obx(() {
                final jumlah = jumlahInput.value;

                final bool isTambah =
                    selectedJenisRequest.value == 'Tambah Stok';

                final int newStock = isTambah
                    ? product.stock + jumlah
                    : product.stock - jumlah;

                final bool invalid = !isTambah && jumlah > product.stock;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: invalid
                        ? Colors.red.withOpacity(0.08)
                        : isTambah
                        ? Colors.green.withOpacity(0.08)
                        : Colors.orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isTambah ? Icons.add_circle : Icons.remove_circle,
                        size: 18,
                        color: invalid
                            ? Colors.red
                            : isTambah
                            ? Colors.green
                            : Colors.orange,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          invalid
                              ? 'Jumlah melebihi stock saat ini'
                              : 'Stock setelah disetujui: $newStock',
                          style: TextStyle(
                            color: invalid
                                ? Colors.red
                                : isTambah
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 12),

              // ==================================================
              // KATEGORI
              // ==================================================
              Obx(
                () => DropdownButtonFormField<String>(
                  value: selectedKategori.value,

                  decoration: InputDecoration(
                    labelText: selectedJenisRequest.value == 'Tambah Stok'
                        ? 'Sumber'
                        : 'Kategori',

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

                  items: kategoriList
                      .map(
                        (kategori) => DropdownMenuItem(
                          value: kategori,
                          child: Text(kategori),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    if (value != null) {
                      selectedKategori.value = value;
                    }
                  },
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // TANGGAL
              // ==================================================
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

              // ==================================================
              // ALASAN
              // ==================================================
              TextField(
                controller: alasanController,

                maxLines: 3,

                decoration: InputDecoration(
                  labelText: 'Alasan',
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

        // ========================================================
        // ACTION
        // ========================================================
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),

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
                  : const Text('Kirim', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // ================================================================
  // DATE PICKER
  // ================================================================

  Future<void> pickTanggal(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggal.value,
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedTanggal.value = picked;
    }
  }

  // ================================================================
  // SUBMIT LAPOR
  // ================================================================

  Future<void> submitLapor(Product product) async {
    final jumlah = int.tryParse(jumlahController.text) ?? 0;

    // ============================================================
    // VALIDASI JUMLAH
    // ============================================================

    if (jumlah <= 0) {
      Get.snackbar(
        'Validasi',
        'Jumlah harus lebih dari 0',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ============================================================
    // CEK JENIS REQUEST
    // ============================================================

    final bool isTambah = selectedJenisRequest.value == 'Tambah Stok';

    // ============================================================
    // VALIDASI KURANG STOK
    // ============================================================

    if (!isTambah && jumlah > product.stock) {
      Get.snackbar(
        'Validasi',
        'Jumlah melebihi stock saat ini (${product.stock})',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ============================================================
    // VALIDASI ALASAN
    // ============================================================

    if (alasanController.text.trim().isEmpty) {
      Get.snackbar(
        'Validasi',
        'Alasan tidak boleh kosong',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ============================================================
    // HITUNG STOCK BARU
    // ============================================================

    final int newStock = isTambah
        ? product.stock + jumlah
        : product.stock - jumlah;

    // ============================================================
    // FORMAT REASON
    // ============================================================

    final tanggalFormatted = DateFormat(
      'dd MMM yyyy',
    ).format(selectedTanggal.value);

    final reasonText =
        '[${selectedJenisRequest.value}] '
        '[${selectedKategori.value}] '
        '$tanggalFormatted - '
        '${alasanController.text.trim()}';

    try {
      Get.back();

      isSubmitting(true);

      // ==========================================================
      // API
      // ==========================================================

      final success = await ApiService.createStockAdjustmentRequest(
        productId: product.id,
        oldStock: product.stock,
        newStock: newStock,
        reason: reasonText,
      );

      if (success) {
        Get.snackbar(
          'Terkirim',
          isTambah
              ? 'Request penambahan stock berhasil dikirim. '
                    'Menunggu persetujuan admin.'
              : 'Laporan pengurangan stock berhasil dikirim. '
                    'Menunggu persetujuan admin.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        await fetchData();
        await fetchHistory();
      } else {
        Get.snackbar(
          'Gagal',
          'Gagal mengirim laporan',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim laporan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting(false);
    }
  }

  // ================================================================
  // DISPOSE
  // ================================================================

  @override
  void onClose() {
    jumlahController.dispose();
    alasanController.dispose();

    super.onClose();
  }
}
