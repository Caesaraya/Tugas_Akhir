import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void sortStockHabis() {
    filteredList.assignAll(originalList.where((e) => e.stok <= 0).toList());

    setupPagination();
  }

  Future<void> insertBahanBaku() async {
    try {
      await ApiService.createBahanBaku(
        BahanBaku(
          namaBahan: namaC.text,
          merk: merkC.text,
          satuan: satuanC.text,
          stok: int.parse(stokC.text),
          hargaSatuan: double.parse(hargaC.text),
        ),
      );

      clearForm();

      fetchData();

      Get.back();

      Get.snackbar('Sukses', 'Bahan baku berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
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
    await ApiService.deleteBahanBaku(id);

    fetchData();
  }
}
