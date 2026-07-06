import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/api service/api_service.dart';
import 'package:tugas_akhir/models/resep.dart';
import 'package:tugas_akhir/page/mobile/bakery_mobile_detail.dart';

class BakeryController extends GetxController {
  var isLoading = false.obs;
  var resepList = <Resep>[].obs;
  var searchQuery = ''.obs;
  var totalBiaya = 0.obs;
  var semuaBahanCukup = true.obs;

  var selectedResep = Rxn<Resep>();
  var jumlahProduksi = 1.obs;
  final inputController = TextEditingController();

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void onInit() {
    super.onInit();
    fetchResep();
    debounce(searchQuery, (_) {}, time: const Duration(milliseconds: 300));
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  Future<void> fetchResep() async {
    try {
      isLoading(true);
      final data = await ApiService.getAllResep();
      resepList.assignAll(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat resep: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> navigateToDetail(Resep resep) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final detail = await ApiService.getDetailResep(resep.id!);

      if (Get.isDialogOpen ?? false) Get.back();
      debugPrint('products: ${detail.products}');
      selectedResep.value = detail;
      jumlahProduksi.value = 1;
      inputController.clear();
      totalBiaya.value = 0;
      semuaBahanCukup.value = true;

      Get.to(() => BakeryDetailPage(resep: detail));
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar(
        'Error',
        'Gagal memuat detail: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  List<Resep> get filteredResep {
    if (searchQuery.value.isEmpty) return resepList;
    return resepList
        .where(
          (r) => r.namaResep.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ),
        )
        .toList();
  }

  double kebutuhanBahan(double jumlahPerResep) =>
      jumlahPerResep * jumlahProduksi.value;

  String get totalBiayaFormatted => currencyFormatter.format(totalBiaya.value);

  String formatQty(double value) => value == value.toInt()
      ? value.toInt().toString()
      : value.toStringAsFixed(2);

  Future<void> setJumlahProduksi(String value, int resepId) async {
    final val = int.tryParse(value) ?? 1;
    jumlahProduksi.value = val < 1 ? 1 : val;
    await loadBakeryCalculation(resepId);
  }

  Future<void> simpanProduksi(int resepId) async {
    if (jumlahProduksi.value < 1) {
      Get.snackbar('Validasi', 'Jumlah produksi minimal 1');
      return;
    }
    try {
      isLoading(true);
      final success = await ApiService.createProduksi(
        productId: resepId,
        jumlahProduksi: jumlahProduksi.value,
      );
      if (success) {
        jumlahProduksi.value = 1;
        inputController.clear();
        totalBiaya.value = 0;
        Get.back();
        Get.snackbar(
          'Sukses',
          'Produksi berhasil dicatat',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchResep();
      } else {
        Get.snackbar(
          'Gagal',
          'Produksi gagal disimpan',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadBakeryCalculation(int resepId) async {
    try {
      final biaya = await ApiService.hitungBiayaProduksi(
        resepId: resepId,
        quantity: jumlahProduksi.value,
      );
      totalBiaya.value = biaya.totalBiaya;

      final availability = await ApiService.cekKetersediaanBahan(
        resepId: resepId,
        quantity: jumlahProduksi.value,
      );
      semuaBahanCukup.value = availability.semuaBahanCukup;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
