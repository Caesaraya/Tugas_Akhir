import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Sesuaikan path
import 'package:tugas_akhir/models/user.dart';
import 'package:tugas_akhir/api service/api_service.dart';

class UserController extends GetxController {
  final RxList<User> users = <User>[].obs;
  final RxList<User> filteredUsers = <User>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;

  final TextEditingController searchController = TextEditingController();

  // Pagination Table (Desktop)
  final RxInt currentPage = 1.obs;
  final int itemsPerPage = 10;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
    fetchUsers();
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  void _onSearchChanged() {
    searchUsers(searchController.text);
  }

  // ========================
  // GET DATA
  // ========================
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final data = await ApiService.getAllUsers();
      users.assignAll(data);
      filteredUsers.assignAll(data);
      currentPage.value = 1;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data user: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========================
  // SEARCH & FILTER
  // ========================
  void searchUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredUsers.assignAll(
        users.where((user) {
          return user.name.toLowerCase().contains(lowerQuery) ||
              user.email.toLowerCase().contains(lowerQuery) ||
              user.role.toLowerCase().contains(lowerQuery);
        }).toList(),
      );
    }
    currentPage.value = 1;
  }

  // ========================
  // PAGINATION LOGIC
  // ========================
  int get totalPages => (filteredUsers.isEmpty)
      ? 1
      : (filteredUsers.length / itemsPerPage).ceil();

  List<User> get paginatedUsers {
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    return filteredUsers.skip(startIndex).take(itemsPerPage).toList();
  }

  void nextPage() {
    if (currentPage.value < totalPages) currentPage.value++;
  }

  void previousPage() {
    if (currentPage.value > 1) currentPage.value--;
  }

  void setPage(int page) {
    if (page >= 1 && page <= totalPages) currentPage.value = page;
  }

  // ========================
  // CRUD OPERATIONS
  // ========================
  Future<void> createUser({
    required String name,
    required String email,
    required String role,
    required String password,
  }) async {
    try {
      isSubmitting.value = true;
      final newUser = User(
        name: name,
        email: email,
        role: role,
        password: password,
      );

      bool success = await ApiService.createUser(newUser);
      if (success) {
        Get.back(); // Tutup dialog
        Get.snackbar(
          'Sukses',
          'Akun berhasil ditambahkan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchUsers();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Hanya mengubah nama, email, dan role.
  // Password lama TIDAK PERNAH diminta atau dikirim di sini.
  Future<void> updateUser({
    required int id,
    required String name,
    required String email,
    required String role,
  }) async {
    try {
      isSubmitting.value = true;
      final updatedUser = User(id: id, name: name, email: email, role: role);

      bool success = await ApiService.updateUser(updatedUser);
      if (success) {
        Get.back(); // Menutup dialog setelah sukses
        Get.snackbar(
          'Sukses',
          'Akun berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchUsers(); // Refresh data table/list
      } else {
        // Jika server merespon status 200 tapi operasi bernilai gagal secara logika bisnis
        Get.snackbar(
          'Gagal',
          'Gagal memperbarui data. Periksa kembali hak akses Anda.',
          backgroundColor: Colors.amber.shade800,
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
    } finally {
      isSubmitting.value = false;
    }
  }

  // ========================
  // RESET PASSWORD
  // ========================
  // Alur khusus Admin: Admin menimpa password lama dengan password baru.
  // Frontend tidak pernah membaca / menampilkan password lama,
  // dan tidak melakukan hashing (hashing dilakukan backend).
  Future<void> resetPassword({
    required int id,
    required String newPassword,
  }) async {
    try {
      isSubmitting.value = true;
      bool success = await ApiService.resetPassword(
        id: id,
        password: newPassword,
      );
      if (success) {
        Get.back();
        Get.snackbar(
          'Sukses',
          'Password akun berhasil direset',
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
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      isSubmitting.value = true;
      bool success = await ApiService.deleteUser(id);
      if (success) {
        Get.back();
        Get.snackbar(
          'Sukses',
          'Akun berhasil dihapus',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchUsers();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus akun: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
