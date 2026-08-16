import 'package:get/get.dart';
import '../../api service/api_service.dart';
import '../../models/stock_adjustment_request.dart';

class LaporanController extends GetxController {
  // Self-registering singleton — aman dipanggil dari sidebar/drawer
  // meskipun belum pernah di-put secara eksplisit di main.dart/binding.
  static LaporanController get to {
    if (!Get.isRegistered<LaporanController>()) {
      Get.put(LaporanController(), permanent: true);
    }
    return Get.find<LaporanController>();
  }

  static const List<String> filterOptions = [
    'Semua',
    'Menunggu',
    'Disetujui',
    'Ditolak',
  ];

  final isLoading = false.obs;
  final isProcessing = false.obs;
  final errorMessage = ''.obs;

  final allReports = <StockAdjustmentRequest>[].obs;
  final selectedFilter = 'Semua'.obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  int get pendingCount => allReports.where((r) => r.status == 'pending').length;

  List<StockAdjustmentRequest> get filteredReports {
    switch (selectedFilter.value) {
      case 'Menunggu':
        return allReports.where((r) => r.status == 'pending').toList();
      case 'Disetujui':
        return allReports.where((r) => r.status == 'approved').toList();
      case 'Ditolak':
        return allReports.where((r) => r.status == 'rejected').toList();
      default:
        return allReports;
    }
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  Future<void> loadReports() async {
    try {
      isLoading(true);
      errorMessage('');
      final data = await ApiService.getAllStockAdjustmentRequests();
      allReports.value = data;
    } catch (e) {
      errorMessage('Gagal memuat laporan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<bool> approveReport(int id) async {
    try {
      isProcessing(true);
      final success = await ApiService.approveStockAdjustmentRequest(id);
      if (success) {
        await loadReports();
      }
      return success;
    } catch (e) {
      errorMessage('Gagal menyetujui laporan: $e');
      return false;
    } finally {
      isProcessing(false);
    }
  }

  Future<bool> rejectReport(int id, String reason) async {
    try {
      isProcessing(true);
      final success = await ApiService.rejectStockAdjustmentRequest(
        id,
        reason: reason,
      );
      if (success) {
        await loadReports();
      }
      return success;
    } catch (e) {
      errorMessage('Gagal menolak laporan: $e');
      return false;
    } finally {
      isProcessing(false);
    }
  }
}
