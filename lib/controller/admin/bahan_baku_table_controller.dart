import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/widget/admin/dialogs/bahan/edit_bahan_baku_dialog.dart';

import '../../api service/api_service.dart';
import '../../models/bahan_baku.dart';
import '../../controller/admin/table/base_table_controller.dart';
import '../../controller/admin/keuangan_controller.dart'; // Import KeuanganController

class BahanBakuTableController extends BaseTableController<BahanBaku> {
  // Ganti nama variable state-nya
  final RxBool filterStokMenipis = false.obs; // Sebelumnya filterStockHabis
  BahanBakuTableController() {
    itemsPerPage = 10;
    // Format harga saat input
    hargaC.addListener(() {
      final raw = hargaC.text;
      final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
      if (clean.isEmpty) return;
      final value = double.tryParse(clean) ?? 0;
      final formatted = currencyFormatter.format(value);
      if (formatted != raw) {
        hargaC.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    });
  }

  final namaC = TextEditingController();
  final merkC = TextEditingController();
  final stokC = TextEditingController();
  final satuanC = TextEditingController();
  final hargaC = TextEditingController();
  final currencyFormatter = NumberFormat('#,###', 'id_ID');

  @override
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final data = await ApiService.getAllBahanBaku(); //

      List<BahanBaku> processedData = data; //

      // 1. Filter data: ambil yang stoknya di bawah 10
      if (filterStokMenipis.value) {
        processedData = processedData.where((item) => item.stok < 10).toList();
      }

      // 2. Logika Pengurutan (Sorting)
      processedData.sort((a, b) {
        // Jika filter aktif, urutkan berdasarkan stok terbesar ke terkecil (Descending)
        if (filterStokMenipis.value) {
          return b.stok.compareTo(a.stok);
        }

        // Urutan default bawaan jika filter tidak aktif (Bahan aktif di atas, soft-deleted di bawah)
        if (a.deletedAt == null && b.deletedAt != null) return -1; //
        if (a.deletedAt != null && b.deletedAt == null) return 1; //
        return 0; //
      });

      setData(processedData); //
    } catch (e) {
      print("Error Fetch Data: $e"); //
      Get.snackbar(
        "Error", //
        "Gagal mengambil data bahan baku: $e", //
        backgroundColor: Colors.red, //
        colorText: Colors.white, //
      );
    } finally {
      isLoading.value = false; //
    }
  }

  // Ganti nama fungsi toggle-nya
  void toggleFilterStokMenipis() {
    filterStokMenipis.value = !filterStokMenipis.value;
    fetchData();
  }

  void toggleFilterStockHabis() {
    filterStokMenipis.value = !filterStokMenipis.value;
    fetchData();
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(originalList);
    } else {
      filteredList.assignAll(
        originalList.where(
          (item) =>
              item.namaBahan.toLowerCase().contains(query.toLowerCase()) ||
              item.merk.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
    currentPage.value = 1;
    setupPagination();
  }

  void refreshData() {
    searchC.clear();
    fetchData();
  }

  void showEditDialog(BahanBaku bahan) {
    namaC.text = bahan.namaBahan;
    merkC.text = bahan.merk;
    stokC.text = bahan.stok == bahan.stok.roundToDouble()
        ? bahan.stok.toInt().toString()
        : bahan.stok.toString();
    satuanC.text = bahan.satuan;
    hargaC.text = currencyFormatter.format(bahan.hargaSatuan);

    Get.dialog(EditBahanBakuDialog(item: bahan));
  }

  // =======================================================================
  // REUSABLE HELPER FUNCTION UNTUK MENCATAT PENGELUARAN KE DATABASE
  // =======================================================================
  Future<void> _recordStockPurchaseExpense({
    required double totalBiaya,
    required String keterangan,
  }) async {
    if (totalBiaya <= 0) return;

    try {
      // Daftarkan atau temukan KeuanganController secara aman
      final keuanganCtrl = Get.isRegistered<KeuanganController>()
          ? Get.find<KeuanganController>()
          : Get.put(KeuanganController());

      // Ambil daftar kategori yang ada di backend
      if (keuanganCtrl.listCategories.isEmpty) {
        await keuanganCtrl.fetchCategories();
      }

      // Cari ID dari kategori "Bahan Baku"
      var targetCategory = keuanganCtrl.listCategories.firstWhereOrNull(
        (cat) => cat.name.toLowerCase() == 'bahan baku',
      );

      int? categoryId = targetCategory?.id;

      // Jika kategori "Bahan Baku" belum ada sama sekali di database backend, buat otomatis
      if (categoryId == null) {
        categoryId = await keuanganCtrl.tambahKategoriBaru('Bahan Baku');
      }

      if (categoryId != null) {
        final tanggalHariIni = DateFormat('yyyy-MM-dd').format(DateTime.now());

        // Simpan transaksi pengeluaran langsung ke database online melalui ApiService
        await ApiService.createExpense(
          tanggal: tanggalHariIni,
          categoryId: categoryId,
          nominal: totalBiaya,
          keterangan: keterangan,
        );

        // Trigerred refresh state keuangan (Summary, Komposisi Chart, & Laporan Tahunan)
        await keuanganCtrl.loadDataKeuangan();
      }
    } catch (e) {
      print("Gagal otomatis mencatat pengeluaran keuangan: $e");
    }
  }

  Future<void> insertBahanBaku() async {
    try {
      final hg = hargaC.text.replaceAll(RegExp(r'[^0-9]'), '');
      final harga = double.tryParse(hg) ?? 0;
      final stok = double.tryParse(stokC.text) ?? 0.0;
      final namaBahan = namaC.text.trim();

      final baru = BahanBaku(
        namaBahan: namaBahan,
        merk: merkC.text.trim(),
        stok: stok,
        satuan: satuanC.text.trim(),
        hargaSatuan: harga,
      );

      final success = await ApiService.createBahanBaku(baru);
      if (success) {
        // Alur A: Jika stok awal saat pembuatan baru > 0, langsung catat pengeluaran ke database
        if (stok > 0) {
          final double totalBiaya = stok * harga;
          await _recordStockPurchaseExpense(
            totalBiaya: totalBiaya,
            keterangan: "Pembelian awal bahan baku $namaBahan",
          );
        }

        Get.back();
        clearForm();
        fetchData();
        Get.snackbar(
          "Sukses",
          "Bahan baku berhasil ditambahkan",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateBahanBaku(int id) async {
    try {
      final hg = hargaC.text.replaceAll(RegExp(r'[^0-9]'), '');
      final harga = double.tryParse(hg) ?? 0;
      final stok = double.tryParse(stokC.text) ?? 0.0;
      final namaBahan = namaC.text.trim();

      final oldItem = originalList.firstWhereOrNull(
        (element) => element.id == id,
      );

      final updateData = BahanBaku(
        id: id,
        namaBahan: namaBahan,
        merk: merkC.text.trim(),
        stok: stok,
        satuan: satuanC.text.trim(),
        hargaSatuan: harga,
      );

      final success = await ApiService.updateBahanBaku(updateData);
      if (success) {
        // Alur B: Bandingkan stok lama dengan stok baru untuk mencatat pengeluaran tambahan
        if (oldItem != null && stok > oldItem.stok) {
          final double selisih = stok - oldItem.stok;
          final double totalBiaya = selisih * harga;

          // Format angka selisih agar tampilan di keterangan rapi (menghilangkan .0 jika integer)
          final String formatSelisih = selisih == selisih.roundToDouble()
              ? selisih.toInt().toString()
              : selisih.toString();

          await _recordStockPurchaseExpense(
            totalBiaya: totalBiaya,
            keterangan:
                "Penambahan stok $namaBahan sebanyak $formatSelisih ${satuanC.text.trim()}",
          );
        }

        Get.back();
        clearForm();
        fetchData();
        Get.snackbar(
          "Sukses",
          "Bahan baku berhasil diubah",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> softDeleteBahan(int id) async {
    Get.dialog(
      AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text(
          "Apakah Anda yakin ingin menghapus bahan baku ini ke tempat sampah?",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back();
              try {
                final res = await ApiService.softDeleteBahanBaku(id);
                if (res) {
                  fetchData();
                  Get.snackbar(
                    "Sukses",
                    "Bahan baku berhasil dipindahkan ke tempat sampah",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              } catch (e) {
                Get.snackbar(
                  "Error",
                  e.toString(),
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> restoreBahan(int id) async {
    Get.dialog(
      AlertDialog(
        title: const Text("Konfirmasi Pulihkan"),
        content: const Text(
          "Apakah Anda yakin ingin mengembalikan bahan baku ini menjadi aktif kembali?",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Get.back();
              try {
                final res = await ApiService.restoreBahanBaku(id);
                if (res) {
                  fetchData();
                  Get.snackbar(
                    "Sukses",
                    "Bahan baku berhasil diaktifkan kembali",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              } catch (e) {
                Get.snackbar(
                  "Error",
                  e.toString(),
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text(
              "Pulihkan",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> forceDeleteBahan(int id) async {
    Get.dialog(
      AlertDialog(
        title: const Text("Hapus Permanen"),
        content: const Text(
          "Tindakan ini tidak dapat dibatalkan. Hapus permanen bahan baku ini?",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade900,
            ),
            onPressed: () async {
              Get.back();
              try {
                final res = await ApiService.forceDeleteBahanBaku(id);
                if (res) {
                  fetchData();
                  if (Get.currentRoute.contains('DetailPage')) {
                    Get.back();
                  }
                  Get.snackbar(
                    "Sukses",
                    "Bahan baku berhasil dihapus secara permanen",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              } catch (e) {
                Get.snackbar(
                  "Error",
                  e.toString(),
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text(
              "Hapus Permanen",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void clearForm() {
    namaC.clear();
    merkC.clear();
    stokC.clear();
    satuanC.clear();
    hargaC.clear();
  }

  @override
  void onClose() {
    namaC.dispose();
    merkC.dispose();
    stokC.dispose();
    satuanC.dispose();
    hargaC.dispose();
    super.onClose();
  }

  double get totalNilaiInventory {
    return originalList.fold(
      0.0,
      (sum, item) => sum + (item.stok * item.hargaSatuan),
    );
  }

  int get totalBahanAktif =>
      originalList.where((e) => e.deletedAt == null).length;

  int get jumlahStokMenipis {
    return originalList
        .where((e) => e.deletedAt == null && e.stok > 0 && e.stok < 10)
        .length;
  }

  int get jumlahStokKritis {
    return originalList.where((e) => e.deletedAt == null && e.stok <= 0).length;
  }

  String formatRingkasanMataUang(double value) {
    if (value >= 1000000000) {
      return 'Rp ${(value / 1000000000).toStringAsFixed(1)}M';
    } else if (value >= 1000000) {
      return 'Rp ${(value / 1000000).toStringAsFixed(1)}Jt';
    } else if (value >= 1000) {
      return 'Rp ${(value / 1000).toStringAsFixed(0)}K';
    }
    return 'Rp ${value.toStringAsFixed(0)}';
  }
}
