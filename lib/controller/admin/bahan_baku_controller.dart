// lib/controllers/bahan_baku_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/models/bahan_baku.dart';
import 'package:tugas_akhir/api service/api_service.dart';

class BahanBakuController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  final RxList<BahanBaku> bahanBakuList = <BahanBaku>[].obs;
  final RxList<BahanBaku> filteredList = <BahanBaku>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString searchQuery = ''.obs;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchAll();
    ever(searchQuery, (_) => _applyFilter());
    ever(bahanBakuList, (_) => _applyFilter());
  }

  // ── Filter ─────────────────────────────────────────────────────────────────
  void _applyFilter() {
    final q = searchQuery.value.toLowerCase();
    if (q.isEmpty) {
      filteredList.assignAll(bahanBakuList);
    } else {
      filteredList.assignAll(
        bahanBakuList.where(
          (b) =>
              b.namaBahan.toLowerCase().contains(q) ||
              b.merk.toLowerCase().contains(q) ||
              b.satuan.toLowerCase().contains(q),
        ),
      );
    }
  }

  void onSearch(String value) => searchQuery.value = value;
  void clearSearch() => searchQuery.value = '';

  // ── FETCH ALL ──────────────────────────────────────────────────────────────
  Future<void> fetchAll() async {
    isLoading.value = true;
    try {
      final data = await ApiService.getAllBahanBaku();
      bahanBakuList.assignAll(data);
    } catch (e) {
      _showError('Gagal memuat data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── CREATE ─────────────────────────────────────────────────────────────────
  Future<bool> create(BahanBaku bahanBaku) async {
    isSaving.value = true;
    try {
      final ok = await ApiService.createBahanBaku(bahanBaku);
      if (ok) {
        _showSuccess('Bahan baku berhasil ditambahkan');
        await fetchAll();
      } else {
        _showError('Gagal menambahkan bahan baku');
      }
      return ok;
    } catch (e) {
      _showError('Error: $e');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ── UPDATE ─────────────────────────────────────────────────────────────────
  Future<bool> updateBahanBaku(BahanBaku bahanBaku) async {
    isSaving.value = true;
    try {
      final ok = await ApiService.updateBahanBaku(bahanBaku);
      if (ok) {
        _showSuccess('Bahan baku berhasil diperbarui');
        await fetchAll();
      } else {
        _showError('Gagal memperbarui bahan baku');
      }
      return ok;
    } catch (e) {
      _showError('Error: $e');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────
  Future<bool> delete(int id) async {
    try {
      final ok = await ApiService.deleteBahanBaku(id);
      if (ok) {
        _showSuccess('Bahan baku berhasil dihapus');
        bahanBakuList.removeWhere((b) => b.id == id);
      } else {
        _showError('Gagal menghapus bahan baku');
      }
      return ok;
    } catch (e) {
      _showError('Error: $e');
      return false;
    }
  }

  // ── Snackbar Helpers ───────────────────────────────────────────────────────
  void _showSuccess(String msg) => Get.snackbar(
    'Berhasil',
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xFF4CAF50).withOpacity(0.95),
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
    borderRadius: 10,
    duration: const Duration(seconds: 2),
    icon: const Icon(Icons.check_circle_outline, color: Colors.white),
  );

  void _showError(String msg) => Get.snackbar(
    'Error',
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xFFEF5350).withOpacity(0.95),
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
    borderRadius: 10,
    duration: const Duration(seconds: 3),
    icon: const Icon(Icons.error_outline, color: Colors.white),
  );
}
