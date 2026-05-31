import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/page/admin/mobile/resep/detail_resep_page.dart';
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
  var selectedBahanId =
      Rxn<int>(); // Menampung ID bahan baku yang dipilih (Aman bertipe int)

  // List reaktif untuk menampung bahan sementara (untuk Insert & Edit)
  var tempBahanList = <DetailResep>[].obs;

  @override
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final data = await ApiService.getAllResep();

      // URUTKAN DATA: Resep aktif (deletedAt == null) di atas, dihapus di bawah
      data.sort((a, b) {
        if (a.deletedAt == null && b.deletedAt != null) return -1;
        if (a.deletedAt != null && b.deletedAt == null) return 1;
        return 0;
      });

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
    if (selectedBahanId.value == null || jumlahBahanC.text.trim().isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Pilih bahan dan isi jumlahnya",
        backgroundColor: Colors.orange,
      );
      return;
    }

    // Mengamankan parsing jumlah bahan ke double dari string input teks
    final double parsedJumlah =
        double.tryParse(jumlahBahanC.text.trim()) ?? 0.0;

    tempBahanList.add(
      DetailResep(bahanId: selectedBahanId.value!, jumlahBahan: parsedJumlah),
    );

    // Reset input bahan baku di dalam dialog form setelah klik tambah
    jumlahBahanC.clear();
    selectedBahanId.value = null;
  }

  void removeBahanFromTemp(int index) {
    tempBahanList.removeAt(index);
  }

  // Alias method untuk menjaga kompatibilitas pemanggilan pada UI dialog lama Anda
  void removeBahanFromTempList(int index) {
    removeBahanFromTemp(index);
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

  // Alias method submitResep agar tombol simpan di dialog insert tetap bekerja normal
  Future<void> submitResep() async {
    await insertResep();
  }

  void _updateItemInList(Resep detail) {
    int index = originalList.indexWhere((element) => element.id == detail.id);
    if (index != -1) {
      originalList[index] = detail;
      filteredList.assignAll(originalList);
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

      Get.back(); // FIX STUCK: Tutup dialog loading terlebih dahulu sebelum memicu re-render UI Obx

      // Jalankan setelah siklus frame UI dibersihkan agar aman dari bentrokan state navigator
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateItemInList(detail);
        clearForm();
        namaResepC.text = detail.namaResep;
        deskripsiC.text = detail.deskripsi;
        tempBahanList.assignAll(detail.bahan ?? []);
        Get.dialog(EditResepDialog(resep: detail));
      });
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Gagal memuat data: $e");
    }
  }

  Future<void> updateResepData(Resep resep) async {
    try {
      if (namaResepC.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Nama resep wajib diisi',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      Resep updatedResep = resep.copyWith(
        namaResep: namaResepC.text,
        deskripsi: deskripsiC.text,
        bahan: tempBahanList.toList(),
      );

      bool success = await ApiService.updateResep(updatedResep);
      if (success) {
        // FIX #2: Tutup dialog DULU, baru fetchData
        // Sebelumnya fetchData() dipanggil tanpa await sebelum Get.back(),
        // menyebabkan isLoading=true berjalan di background setelah dialog tertutup
        Get.back();
        Get.snackbar(
          'Sukses',
          'Resep berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchData(); // fire-and-forget setelah dialog sudah bersih dari layar
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

  // Alias method updateResep yang dipanggil dari EditResepDialog
  Future<void> updateResep(int id) async {
    Resep resepData = Resep(
      id: id,
      namaResep: namaResepC.text,
      deskripsi: deskripsiC.text,
    );
    await updateResepData(resepData);
  }

  Future<void> deleteData(int id) async {
    Get.defaultDialog(
      title: "Konfirmasi Hapus",
      middleText: "Hapus resep ini? Data akan dipindahkan ke daftar terhapus.",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        try {
          bool success = await ApiService.softDeleteResep(id);
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

  Future<void> restoreData(int id) async {
    Get.defaultDialog(
      title: "Konfirmasi Restore",
      middleText: "Kembalikan resep ini ke daftar aktif?",
      textConfirm: "Ya, Restore",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () async {
        Get.back();
        try {
          bool success = await ApiService.restoreResep(id);
          if (success) {
            Get.snackbar(
              "Berhasil",
              "Resep berhasil direstore",
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

  Future<void> forceDeleteData(int id) async {
    Get.defaultDialog(
      title: "Konfirmasi Hapus Permanen",
      middleText:
          "Hapus resep ini secara permanen? Data bahan di dalamnya juga akan terhapus selamanya.",
      textConfirm: "Ya, Hapus Permanen",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        try {
          bool success = await ApiService.forceDeleteResep(id);
          if (success) {
            Get.snackbar(
              "Berhasil",
              "Resep berhasil dihapus permanen",
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

  void goToDetailDesktop(Resep resep) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      Resep detail = await ApiService.getDetailResep(resep.id!);

      // FIX #1: Tutup loading DULU sebelum mutasi state apapun
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // FIX #1: _updateItemInList dipindah ke SETELAH Get.back()
      // agar tidak memicu Obx rebuild saat loading dialog masih di layar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateItemInList(detail);
        Get.dialog(DetailResepDialog(resep: detail));
      });
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void goToDetailMobile(Resep resep) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      Resep detail = await ApiService.getDetailResep(resep.id!);

      // FIX #1: Sama — tutup loading dulu, baru mutasi state
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateItemInList(detail);
        Get.to(() => DetailResepMobilePage(resep: detail));
      });
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
