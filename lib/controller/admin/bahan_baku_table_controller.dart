import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/widget/admin/dialogs/bahan/edit_bahan_baku_dialog.dart';
import 'package:tugas_akhir/widget/admin/dialogs/bahan/insert_bahan_baku_dialog.dart';

import '../../api service/api_service.dart';
import '../../models/bahan_baku.dart';
import '../../controller/admin/table/base_table_controller.dart';

class BahanBakuTableController extends BaseTableController<BahanBaku> {
  // Properti filter bawaan desktop Anda tetap dipertahankan
  final RxBool filterStockHabis = false.obs;

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
  @override
  void onInit() {
    super.onInit();
    itemsPerPage = 25;
    // Register listener sekali saja di sini, bukan di constructor
    hargaC.addListener(_onPriceChanged);

    // Otomatis fetch data saat controller dibuat / di-recreate oleh fenix
    fetchData();
  }

  final namaC = TextEditingController();
  final merkC = TextEditingController();
  final stokC = TextEditingController();
  final satuanC = TextEditingController();
  final hargaC = TextEditingController();
  final currencyFormatter = NumberFormat('#,###', 'id_ID');

  // SATU FUNGSI FETCH DATA GABUNGAN (Aman untuk Desktop & Mobile)
  @override
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final data = await ApiService.getAllBahanBaku();

      // Menjalankan penyaringan filterStockHabis bawaan Desktop Anda jika aktif
      List<BahanBaku> processedData = data;
      if (filterStockHabis.value) {
        processedData = processedData.where((item) => item.stok <= 0).toList();
      }

      // Urutkan data secara aman: Data aktif di atas, data terhapus (Soft-Delete) di bawah
      processedData.sort((a, b) {
        if (a.deletedAt == null && b.deletedAt != null) return -1;
        if (a.deletedAt != null && b.deletedAt == null) return 1;
        return 0;
      });

      setData(processedData);
    } catch (e) {
      print("Error Fetch Data: $e");
      Get.snackbar(
        "Error",
        "Gagal mengambil data bahan baku: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _formatRibuan(int value) {
    return currencyFormatter.format(value);
  }

  /// Parse string ribuan kembali ke int, misal "100.000" → 100000
  int _parseRibuan(String text) {
    return int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  void _onPriceChanged() {
    final text = hargaC.text;
    if (text.isEmpty) return;

    final clean = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.isEmpty) {
      hargaC.value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      return;
    }

    final value = int.tryParse(clean) ?? 0;
    final formatted = _formatRibuan(value);

    // Hitung posisi kursor agar tidak melompat ke akhir secara paksa
    int cursorPosition = hargaC.selection.baseOffset;
    int numCharsBeforeCursor = text
        .substring(0, max(0, cursorPosition))
        .replaceAll(RegExp(r'[^0-9]'), '')
        .length;

    int newCursorPosition = 0;
    int digitCount = 0;
    while (newCursorPosition < formatted.length &&
        digitCount < numCharsBeforeCursor) {
      if (RegExp(r'[0-9]').hasMatch(formatted[newCursorPosition])) {
        digitCount++;
      }
      newCursorPosition++;
    }

    if (formatted != text) {
      hargaC.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(
          offset: min(newCursorPosition, formatted.length),
        ),
      );
    }
  }

  // Fungsi toggle filter bawaan Desktop Anda tetap utuh
  void toggleFilterStockHabis() {
    filterStockHabis.value = !filterStockHabis.value;
    fetchData(); // Panggil ulang data setelah filter diubah
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
    // Mengamankan tampilan angka stok di dalam input form (.0 dibuang)
    stokC.text = bahan.stok == bahan.stok.roundToDouble()
        ? bahan.stok.toInt().toString()
        : bahan.stok.toString();
    satuanC.text = bahan.satuan;
    hargaC.text = currencyFormatter.format(bahan.hargaSatuan);

    Get.dialog(EditBahanBakuDialog(item: bahan));
  }

  Future<void> insertBahanBaku() async {
    try {
      final hg = hargaC.text.replaceAll(RegExp(r'[^0-9]'), '');
      final harga = double.tryParse(hg) ?? 0;
      final stok = double.tryParse(stokC.text) ?? 0.0;

      final baru = BahanBaku(
        namaBahan: namaC.text.trim(),
        merk: merkC.text.trim(),
        stok: stok,
        satuan: satuanC.text.trim(),
        hargaSatuan: harga,
      );

      final success = await ApiService.createBahanBaku(baru);
      if (success) {
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

      final updateData = BahanBaku(
        id: id,
        namaBahan: namaC.text.trim(),
        merk: merkC.text.trim(),
        stok: stok,
        satuan: satuanC.text.trim(),
        hargaSatuan: harga,
      );

      final success = await ApiService.updateBahanBaku(updateData);
      if (success) {
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

  // --- METHOD UNTUK MEMBUKA DIALOG INSERT ---
  void openInsertDialog() {
    // Bersihkan data formulir sisa sebelumnya agar kembali suci
    clearForm();

    // Pastikan UI memperbarui state sebelum menampilkan dialog baru
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(const InsertBahanBakuDialog());
    });
  }

  // --- METHOD UNTUK MEMBUKA DIALOG EDIT ---
  void openEditDialog(BahanBaku item) {
    // Bersihkan formulir terlebih dahulu
    clearForm();

    // Isi controller dengan data item bahan baku yang dipilih
    namaC.text = item.namaBahan;
    merkC.text = item.merk ?? '';
    satuanC.text = item.satuan;
    stokC.text = item.stok.toString();
    hargaC.text = currencyFormatter.format(item.hargaSatuan);

    // Buka dialog edit bahan baku
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(EditBahanBakuDialog(item: item));
    });
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

  // Perhitungan Ringkasan / Summary Card Utama (Mendukung tipe double secara presisi)
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
