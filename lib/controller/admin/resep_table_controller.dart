import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/widget/admin/dialogs/resep/detail_resep_dialog.dart';
import 'package:tugas_akhir/widget/admin/dialogs/resep/edit_resep_dialog.dart';
import 'package:tugas_akhir/widget/admin/dialogs/resep/insert_resep_dialogs.dart';
import '../../api service/api_service.dart';
import '../../models/resep.dart';
import '../../controller/admin/table/base_table_controller.dart';

class ResepTableController extends BaseTableController<Resep> {
  ResepTableController() {
    itemsPerPage = 10;
  }

  // Controller untuk Form Utama
  final namaResepC = TextEditingController();
  final deskripsiC = TextEditingController();

  // Controller untuk Input Bahan di dalam Dialog
  final jumlahBahanC = TextEditingController();
  var selectedBahanId = Rxn<int>(); // Menampung ID bahan baku yang dipilih

  // List reaktif untuk menampung bahan sementara (untuk Insert & Edit)
  var tempBahanList = <DetailResep>[].obs;

  @override
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final data = await ApiService.getAllResep();

      // CEK DI CONSOLE LOG:
      if (data.isNotEmpty) {
        print(
          "Resep pertama: ${data[0].namaResep}, Jumlah Bahan: ${data[0].bahan?.length}",
        );
      }
      setData(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data resep: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
        originalList.where((resep) {
          return resep.namaResep.toLowerCase().contains(searchText) ||
              resep.deskripsi.toLowerCase().contains(searchText) ||
              resep.id.toString().contains(searchText);
        }).toList(),
      );
    }
    currentPage.value = 1;
    setupPagination();
  }

  // --- LOGIKA MANAJEMEN BAHAN (TEMP LIST) ---

  void addBahanToTempList() {
    if (selectedBahanId.value == null || jumlahBahanC.text.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Pilih bahan dan isi jumlahnya",
        backgroundColor: Colors.orange,
      );
      return;
    }

    // Tambah ke list sementara
    tempBahanList.add(
      DetailResep(
        bahanId: selectedBahanId.value!,
        jumlahBahan: double.tryParse(jumlahBahanC.text) ?? 0,
      ),
    );

    // Reset input bahan
    jumlahBahanC.clear();
    selectedBahanId.value = null;
  }

  void removeBahanFromTemp(int index) {
    tempBahanList.removeAt(index);
  }

  void clearForm() {
    namaResepC.clear();
    deskripsiC.clear();
    jumlahBahanC.clear();
    tempBahanList.clear();
    selectedBahanId.value = null;
  }

  // --- ACTIONS (INSERT, EDIT, DETAIL, DELETE) ---

  void openInsertDialog() {
    clearForm();
    Get.dialog(InsertResepDialog());
  }

  Future<void> insertResep() async {
    try {
      if (namaResepC.text.isEmpty) {
        Get.snackbar('Error', 'Nama resep wajib diisi');
        return;
      }

      Resep newResep = Resep(
        namaResep: namaResepC.text,
        deskripsi: deskripsiC.text,
        bahan: tempBahanList.toList(),
      );

      bool success = await ApiService.createResep(newResep);
      if (success) {
        fetchData();
        Get.back();
        Get.snackbar(
          'Sukses',
          'Resep berhasil ditambahkan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void _updateItemInList(Resep detail) {
    int index = originalList.indexWhere((element) => element.id == detail.id);
    if (index != -1) {
      originalList[index] =
          detail; // Timpa data lama (0 bahan) dengan data baru (lengkap)
      filteredList.assignAll(originalList); // Trigger UI Tabel untuk refresh
      setupPagination();
    }
  }

  void openEditDialog(Resep resep) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      Resep detail = await ApiService.getDetailResep(resep.id!);

      // Sinkronkan ke tabel utama
      _updateItemInList(detail);

      Get.back(); // Tutup loading

      clearForm();
      namaResepC.text = detail.namaResep;
      deskripsiC.text = detail.deskripsi;
      tempBahanList.assignAll(detail.bahan ?? []);

      Get.dialog(EditResepDialog(resep: detail));
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Gagal memuat data: $e");
    }
  }

  Future<void> updateResepData(Resep resep) async {
    try {
      Resep updatedResep = resep.copyWith(
        namaResep: namaResepC.text,
        deskripsi: deskripsiC.text,
        bahan: tempBahanList.toList(),
      );

      bool success = await ApiService.updateResep(updatedResep);
      if (success) {
        fetchData();
        Get.back();
        Get.snackbar(
          'Sukses',
          'Resep berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void showDetailBahan(Resep resep) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      Resep detail = await ApiService.getDetailResep(resep.id!);

      // Sinkronkan ke tabel utama
      _updateItemInList(detail);

      Get.back(); // Tutup loading
      Get.dialog(DetailResepDialog(resep: detail));
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Gagal memuat detail: $e");
    }
  }

  Future<void> deleteData(int id) async {
    Get.defaultDialog(
      title: "Konfirmasi Hapus",
      middleText: "Hapus resep ini? Data bahan di dalamnya juga akan terhapus.",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        try {
          bool success = await ApiService.deleteResep(id);
          if (success) {
            Get.snackbar(
              "Berhasil",
              "Resep berhasil dihapus",
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            fetchData();
          }
        } catch (e) {
          Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
        }
      },
    );
  }
}
