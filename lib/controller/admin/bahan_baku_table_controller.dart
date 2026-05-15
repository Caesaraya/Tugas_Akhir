import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/widget/admin/dialogs/bahan/edit_bahan_baku_dialog.dart';

import '../../api service/api_service.dart';
import '../../models/bahan_baku.dart';
import '../../controller/admin/table/base_table_controller.dart';

class BahanBakuTableController extends BaseTableController<BahanBaku> {
  BahanBakuTableController() {
    itemsPerPage = 10;
  }

  final namaC = TextEditingController();
  final merkC = TextEditingController();
  final stokC = TextEditingController();
  final satuanC = TextEditingController();
  final hargaC = TextEditingController();

  // State untuk sort bolak-balik
  var isAscending = true.obs;
  var isFilterStockHabis = false.obs;

  @override
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final data = await ApiService.getAllBahanBaku();
      setData(data);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void search(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(originalList);
    } else {
      final searchText = query.toLowerCase();
      filteredList.assignAll(
        originalList.where((e) {
          return e.namaBahan.toLowerCase().contains(searchText) ||
              e.merk.toLowerCase().contains(searchText) ||
              e.satuan.toLowerCase().contains(searchText) ||
              e.stok.toString().contains(searchText) ||
              e.hargaSatuan.toString().contains(searchText);
        }).toList(),
      );
    }
    currentPage.value = 1;
    setupPagination();
  }

  // Method Sort Bolak-Balik (Toggle)
  void sortStockHabis() {
    isAscending.value = !isAscending.value;
    List<BahanBaku> sortedData = List.from(originalList);

    sortedData.sort((a, b) {
      return isAscending.value
          ? a.stok.compareTo(b.stok)
          : b.stok.compareTo(a.stok);
    });

    filteredList.assignAll(sortedData);
    currentPage.value = 1;
    setupPagination();
  }

  // Method Filter Stok Habis (Toggle)
  void toggleFilterStockHabis() {
    isFilterStockHabis.value = !isFilterStockHabis.value;
    if (isFilterStockHabis.value) {
      filteredList.assignAll(originalList.where((e) => e.stok <= 0).toList());
    } else {
      filteredList.assignAll(originalList);
    }
    currentPage.value = 1;
    setupPagination();
  }

  Future<void> insertBahanBaku() async {
    try {
      // 1. Cari ID terakhir/terbesar dari list yang sudah ada
      int newId = 1; // Default jika list kosong
      if (originalList.isNotEmpty) {
        // Mengambil ID tertinggi menggunakan map dan reduce
        newId =
            originalList.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) +
            1;
      }

      // 2. Masukkan ke dalam model BahanBaku
      bool success = await ApiService.createBahanBaku(
        BahanBaku(
          id: newId, // Gunakan ID baru di sini
          namaBahan: namaC.text,
          merk: merkC.text,
          satuan: satuanC.text,
          stok: double.parse(stokC.text),
          hargaSatuan: double.parse(hargaC.text),
        ),
      );

      if (success) {
        clearForm();
        fetchData();
        Get.back();
        Get.snackbar(
          'Sukses',
          'Bahan baku berhasil ditambahkan dengan ID $newId',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Pastikan semua field terisi dengan benar: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Persiapan Dialog Edit
  void openEditDialog(BahanBaku bahan) {
    namaC.text = bahan.namaBahan;
    merkC.text = bahan.merk;
    satuanC.text = bahan.satuan;
    stokC.text = bahan.stok.toString();
    hargaC.text = bahan.hargaSatuan.toString();

    // Panggil dialog (UI dibuat terpisah seperti Insert dialog)
    Get.dialog(EditBahanBakuDialog(bahan: bahan));
  }

  Future<void> updateBahanBaku(int id) async {
    try {
      bool success = await ApiService.updateBahanBaku(
        BahanBaku(
          id: id,
          namaBahan: namaC.text,
          merk: merkC.text,
          satuan: satuanC.text,
          stok: double.parse(stokC.text),
          hargaSatuan: double.parse(hargaC.text),
        ),
      );

      if (success) {
        clearForm();
        fetchData();
        Get.back();
        Get.snackbar(
          'Sukses',
          'Bahan baku berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearForm() {
    namaC.clear();
    merkC.clear();
    stokC.clear();
    satuanC.clear();
    hargaC.clear();
  }

  Future<void> deleteData(int id) async {
    Get.defaultDialog(
      title: "Konfirmasi Hapus",
      middleText: "Yakin ingin menghapus bahan baku ini?",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        try {
          bool success = await ApiService.deleteBahanBaku(id);
          if (success) {
            Get.snackbar(
              "Berhasil",
              "Bahan baku dihapus",
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            fetchData();
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
    );
  }
}
