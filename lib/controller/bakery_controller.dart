import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/api service/api_service.dart';
import 'package:tugas_akhir/models/bahan_baku_requirement.dart';
import 'package:tugas_akhir/models/resep.dart';
import 'package:tugas_akhir/models/bahan_baku.dart';
import 'package:tugas_akhir/models/bahan_cart.dart';
import 'package:tugas_akhir/page/mobile/bakery_mobile_detail.dart';
import 'package:tugas_akhir/page/mobile/bakery_production_preview.dart';
import 'package:tugas_akhir/controller/admin/keuangan_controller.dart';

class BakeryController extends GetxController {
  var isLoading = false.obs;
  var resepList = <Resep>[].obs;
  var bahanBakuList =
      <BahanBaku>[].obs; 
  var searchQuery = ''.obs;
  var totalBiaya = 0.obs;
  var semuaBahanCukup = true.obs;

  var selectedResep = Rxn<Resep>();
  var jumlahProduksi = 1.obs;
  final inputController = TextEditingController();
  var manualCart = <ManualBahanCartItem>[].obs;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void onInit() {
    super.onInit();
    fetchResep();
    fetchBahanBaku();
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
  List<Resep> get filteredResep {
    if (searchQuery.isEmpty) return resepList;
    return resepList
        .where(
          (r) => r.namaResep.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ),
        )
        .toList();
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

  Future<void> fetchBahanBaku() async {
    try {
      final data = await ApiService.getAllBahanBaku();
      bahanBakuList.assignAll(data);
    } catch (e) {
      debugPrint("Gagal memuat bahan baku: $e");
    }
  }
  void tambahKeKeranjangManualDenganQty(BahanBaku bahan, double qty) {
    final index = manualCart.indexWhere((item) => item.bahan.id == bahan.id);

    if (index == -1) {
      manualCart.add(ManualBahanCartItem(bahan: bahan, qtyAmbil: qty));
      Get.snackbar(
        'Sukses',
        '${bahan.namaBahan} berhasil masuk keranjang',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      double qtyBaru = manualCart[index].qtyAmbil + qty;
      if (qtyBaru > bahan.stok) {
        Get.snackbar(
          'Gagal Akumulasi',
          'Total di keranjang melebihi batas stok tersedia!',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      manualCart[index].qtyAmbil = qtyBaru;
      manualCart.refresh();
      Get.snackbar(
        'Updated',
        'Jumlah ${bahan.namaBahan} di keranjang diperbarui',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
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

      selectedResep.value = detail;
      jumlahProduksi.value = 1;
      inputController.text = "1";
      totalBiaya.value = 0;
      semuaBahanCukup.value = true;

      await loadBakeryCalculation(detail.id!);
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

  double kebutuhanBahan(double jumlahPerResep) =>
      jumlahPerResep * jumlahProduksi.value;
  String get totalBiayaFormatted => currencyFormatter.format(totalBiaya.value);
  String formatQty(double value) => value == value.toInt()
      ? value.toInt().toString()
      : value.toStringAsFixed(2);
  void validasiDanBukaPreview() {
    final resep = selectedResep.value;
    if (resep == null || resep.bahan == null) return;

    int maxProduksiBisa = jumlahProduksi.value;
    bool adaKekuranganStok = false;

    for (var bReq in resep.bahan!) {
      final realBahan = bahanBakuList.firstWhereOrNull(
        (element) => element.id == bReq.bahanId,
      );
      double stokSekarang = realBahan?.stok ?? 0.0;
      double butuhPerPcs = bReq.jumlahBahan;

      double totalKebutuhan = butuhPerPcs * jumlahProduksi.value;
      if (totalKebutuhan > stokSekarang) {
        adaKekuranganStok = true;
        int batasBahanIni = (stokSekarang / butuhPerPcs).floor();
        if (batasBahanIni < maxProduksiBisa) {
          maxProduksiBisa = batasBahanIni;
        }
      }
    }

    if (adaKekuranganStok) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Stok tidak mencukupi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Stok bahan baku tidak mencukupi untuk memproduksi ${jumlahProduksi.value} pcs. Berdasarkan sisa stok paling sedikit, produksi maksimal adalah $maxProduksiBisa pcs.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE89336),
              ),
              onPressed: () async {
                Get.back();
                if (maxProduksiBisa < 1) {
                  Get.snackbar(
                    'Gagal',
                    'Stok benar-benar habis, tidak bisa melakukan produksi',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                jumlahProduksi.value = maxProduksiBisa;
                inputController.text = maxProduksiBisa.toString();
                await loadBakeryCalculation(resep.id!);
                Get.to(() => const BakeryProductionPreviewPage());
              },
              child: Text(
                'Lanjutkan Produksi $maxProduksiBisa pcs',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else {
      Get.to(() => const BakeryProductionPreviewPage());
    }
  }
  Future<void> simpanTransaksiProduksi() async {
    try {
      isLoading(true);
      final resep = selectedResep.value;
      if (resep == null) return;

      final rawResult = await ApiService.confirmPengambilanBahanResep(
        resepId: resep.id!,
        jumlahProduksi: jumlahProduksi.value,
      );
      final result = PengambilanBahanResepResult.fromJson(rawResult);

      Get.until((route) => Get.currentRoute == '/BakeryPage' || route.isFirst);
      Get.snackbar(
        'Sukses',
        'Pengambilan bahan untuk resep "${result.namaResep}" berhasil diproses',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      await fetchResep();
      await fetchBahanBaku();

      if (Get.isRegistered<KeuanganController>()) {
        final keuanganCtrl = Get.find<KeuanganController>();
        await keuanganCtrl.loadDashboardData();
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void tambahKeKeranjangManual(BahanBaku bahan) {
    final ada = manualCart.firstWhereOrNull(
      (item) => item.bahan.id == bahan.id,
    );
    if (ada == null) {
      manualCart.add(ManualBahanCartItem(bahan: bahan, qtyAmbil: 1.0));
      Get.snackbar('Berhasil', '${bahan.namaBahan} ditambahkan ke daftar');
    } else {
      Get.snackbar('Info', '${bahan.namaBahan} sudah ada di daftar');
    }
  }

  void updateQtyManualCart(int index, double value) {
    if (value <= 0) return;
    if (value > manualCart[index].bahan.stok) {
      Get.snackbar(
        'Melebihi Stok',
        'Jumlah pengambilan tidak boleh melampaui sisa stok bahan!',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    manualCart[index].qtyAmbil = value;
    manualCart.refresh();
  }

  Future<void> kirimPengambilanManual() async {
    if (manualCart.isEmpty) return;
    try {
      isLoading(true);
      List<Map<String, dynamic>> payload = manualCart
          .map((item) => {"bahan_baku_id": item.bahan.id, "qty": item.qtyAmbil})
          .toList();

      bool success = await ApiService.createPengambilanBahanManual(
        items: payload,
      );

      if (success) {
        manualCart.clear();
        Get.back();
        Get.snackbar(
          'Sukses',
          'Pengambilan bahan baku manual berhasil disimpan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await fetchBahanBaku();
        if (Get.isRegistered<KeuanganController>()) {
          await Get.find<KeuanganController>().loadDashboardData();
        }
      } else {
        Get.snackbar(
          'Gagal',
          'Proses backend gagal menyimpan data pengambilan',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Kesalahan koneksi: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadBakeryCalculation(int resepId) async {
    try {
      isLoading(true);
      final resepTarget = resepList.firstWhereOrNull((r) => r.id == resepId);
      if (resepTarget == null) {
        Get.snackbar(
          'Error',
          'Resep tidak ditemukan di dalam sistem.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      final biaya = await ApiService.hitungBiayaProduksi(
        resepId: resepId,
        quantity: jumlahProduksi.value,
      );
      totalBiaya.value = biaya.totalBiaya;
    } catch (e) {
      print("ERROR DI LOAD CALCULATION: $e");
      Get.snackbar(
        'Gagal Memuat',
        'Gagal menghitung estimasi produksi: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
