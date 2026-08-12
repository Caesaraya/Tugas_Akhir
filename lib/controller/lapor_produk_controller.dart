import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/api service/api_service.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/models/stock_adjustment_request.dart';

class LaporProdukController extends GetxController {
  // ========================
  // PRODUK
  // ========================

  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;

  var isLoading = false.obs;
  var isSubmitting = false.obs;

  var searchQuery = "".obs;
  var currentPage = 1.obs;

  static const int pageSize = 15;

  // ========================
  // RIWAYAT LAPORAN
  // ========================

  var laporanList = <StockAdjustmentRequest>[].obs;
  var isLoadingLaporan = false.obs;

  var laporanSearchQuery = "".obs;

  List<StockAdjustmentRequest> get filteredLaporan {
    if (laporanSearchQuery.value.trim().isEmpty) {
      return laporanList;
    }

    final query = laporanSearchQuery.value.toLowerCase().trim();

    return laporanList.where((laporan) {
      return laporan.productName.toLowerCase().contains(query) ||
          laporan.reason.toLowerCase().contains(query) ||
          laporan.status.toLowerCase().contains(query);
    }).toList();
  }

  // ========================
  // PAGINATION PRODUK
  // ========================

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

  // ========================
  // FORMATTER
  // ========================

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // ========================
  // FORM LAPOR
  // ========================

  final jumlahController = TextEditingController();
  final alasanController = TextEditingController();

  final listKategori = const ['Rusak', 'Kadaluwarsa'];

  final selectedKategori = 'Rusak'.obs;
  final selectedTanggal = DateTime.now().obs;

  // ========================
  // INIT
  // ========================

  @override
  void onInit() {
    super.onInit();

    fetchData();
    fetchLaporan();

    debounce(
      searchQuery,
      (_) => runFilter(),
      time: const Duration(milliseconds: 500),
    );
  }

  // ========================
  // FETCH PRODUK
  // ========================

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
        "Error",
        "Gagal memuat produk: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // ========================
  // FILTER PRODUK
  // ========================

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

  // ========================
  // FETCH RIWAYAT LAPORAN
  // ========================

  Future<void> fetchLaporan() async {
    try {
      isLoadingLaporan(true);

      final data = await ApiService.getMyStockAdjustmentRequests();

      laporanList.assignAll(data);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat riwayat laporan: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingLaporan(false);
    }
  }

  // ========================
  // REFRESH
  // ========================

  Future<void> refreshData() async {
    await Future.wait([fetchData(), fetchLaporan()]);
  }

  // ========================
  // STATUS
  // ========================

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Diterima';

      case 'rejected':
        return 'Ditolak';

      case 'pending':
        return 'Menunggu';

      default:
        return status;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      case 'pending':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;

      case 'rejected':
        return Icons.cancel;

      case 'pending':
        return Icons.access_time;

      default:
        return Icons.info;
    }
  }

  // ========================
  // DETAIL LAPORAN
  // ========================

  void showLaporanDetail(BuildContext context, StockAdjustmentRequest laporan) {
    final status = laporan.status.toLowerCase();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(
              getStatusIcon(laporan.status),
              color: getStatusColor(laporan.status),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Detail Laporan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Produk', laporan.productName),

              _detailRow('Stok Awal', '${laporan.oldStock}'),

              _detailRow('Stok Setelah', '${laporan.newStock}'),

              _detailRow(
                'Status',
                getStatusText(laporan.status),
                valueColor: getStatusColor(laporan.status),
              ),

              if (laporan.approvedByName != null &&
                  laporan.approvedByName!.isNotEmpty)
                _detailRow(
                  status == 'approved' ? 'Disetujui Oleh' : 'Diproses Oleh',
                  laporan.approvedByName!,
                ),

              if (laporan.createdAt != null)
                _detailRow(
                  'Tanggal Laporan',
                  DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(laporan.createdAt!.toLocal()),
                ),

              if (laporan.updatedAt != null)
                _detailRow(
                  'Terakhir Diperbarui',
                  DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(laporan.updatedAt!.toLocal()),
                ),

              const SizedBox(height: 12),

              const Text(
                'Alasan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),

              const SizedBox(height: 6),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  laporan.reason,
                  style: const TextStyle(fontSize: 13),
                ),
              ),

              if (status == 'approved') ...[
                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.withOpacity(0.25)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.inventory_2_outlined, color: Colors.green),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Laporan telah diterima. Stok produk sudah diperbarui sesuai laporan.',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (status == 'rejected') ...[
                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.red),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Laporan ditolak. Stok produk tidak diubah.',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Tutup')),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========================
  // FORM LAPOR
  // ========================

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

              TextField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      selectedKategori.value = val;
                    }
                  },
                ),
              ),

              const SizedBox(height: 12),

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

  // ========================
  // PICK TANGGAL
  // ========================

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

  // ========================
  // SUBMIT LAPOR
  // ========================

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

    final tanggalFormatted = DateFormat(
      'dd MMM yyyy',
    ).format(selectedTanggal.value);

    final reasonText =
        "[${selectedKategori.value}] "
        "$tanggalFormatted - "
        "${alasanController.text.trim()}";

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
        await fetchLaporan();

        Get.snackbar(
          "Terkirim",
          "Laporan berhasil dikirim, menunggu persetujuan admin",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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

  // ========================
  // CLOSE
  // ========================

  @override
  void onClose() {
    jumlahController.dispose();
    alasanController.dispose();

    super.onClose();
  }
}
