import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Package untuk tracking lokal
import 'package:intl/intl.dart';
import 'package:tugas_akhir/widget/admin/dialogs/bahan/edit_bahan_baku_dialog.dart';

import '../../api service/api_service.dart';
import '../../models/bahan_baku.dart';
import '../../controller/admin/table/base_table_controller.dart';

class BahanBakuTableController extends BaseTableController<BahanBaku> {
  final RxBool filterStockHabis = false.obs;
  final _storage = GetStorage(); // Inisialisasi storage tracker

  BahanBakuTableController() {
    itemsPerPage = 10;
    // Format harga saat input (Bawaan asli Anda)
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
      final data = await ApiService.getAllBahanBaku();

      List<BahanBaku> processedData = data;
      if (filterStockHabis.value) {
        processedData = processedData.where((item) => item.stok <= 0).toList();
      }

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

  void toggleFilterStockHabis() {
    filterStockHabis.value = !filterStockHabis.value;
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

  // Tetap menggunakan nama fungsi asli bawaan Anda agar dialog terbuka dengan benar
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
        // =======================================================================
        // TRACKING PENGELUARAN UNTUK BAHAN BAKU BARU (Hanya jika stok awal > 0)
        // =======================================================================
        if (stok > 0) {
          final double totalBiaya = stok * harga;

          final mapHistori = {
            'tanggal': DateTime.now().toIso8601String(),
            'bahan_baku_id': DateTime.now()
                .millisecondsSinceEpoch, // ID sementara sebelum reload data
            'nama_bahan': namaC.text.trim(),
            'stok_sebelum': 0.0,
            'stok_sesudah': stok,
            'jumlah_penambahan': stok,
            'harga_satuan': harga,
            'total_pengeluaran': totalBiaya,
          };

          List<dynamic> localData = _storage.read('histori_pengeluaran') ?? [];
          localData.add(mapHistori);
          await _storage.write('histori_pengeluaran', localData);
        }
        // =======================================================================

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

      // =======================================================================
      // TRACKING PENGELUARAN UNTUK UPDATE/TAMBAH STOK (Bahan Baku Lama)
      // =======================================================================
      final oldItem = originalList.firstWhereOrNull(
        (element) => element.id == id,
      );

      if (oldItem != null && stok > oldItem.stok) {
        final double selisih = stok - oldItem.stok;
        final double totalBiaya = selisih * harga;

        final mapHistori = {
          'tanggal': DateTime.now().toIso8601String(),
          'bahan_baku_id': id,
          'nama_bahan': namaC.text.trim(),
          'stok_sebelum': oldItem.stok,
          'stok_sesudah': stok,
          'jumlah_penambahan': selisih,
          'harga_satuan': harga,
          'total_pengeluaran': totalBiaya,
        };

        List<dynamic> localData = _storage.read('histori_pengeluaran') ?? [];
        localData.add(mapHistori);
        await _storage.write('histori_pengeluaran', localData);
      }
      // =======================================================================

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
