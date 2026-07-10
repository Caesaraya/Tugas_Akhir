import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/controller/admin/user_controller.dart';
import 'package:tugas_akhir/widget/admin/custom_sidebar.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';
import 'package:tugas_akhir/widget/admin/table/table_toolbar.dart';
import 'package:tugas_akhir/widget/admin/table/table_header_cell.dart';
import 'package:tugas_akhir/widget/admin/table/table_row_cell.dart';
import 'package:tugas_akhir/widget/admin/table/table_action_button.dart';
import 'package:tugas_akhir/widget/admin/table/table_pagination.dart';
import 'package:tugas_akhir/widget/admin/dialogs/user/user_dialogs.dart';

class KelolaUserDeskPage extends StatelessWidget {
  KelolaUserDeskPage({super.key});

  final ctrl = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<NavigationController>().selectedIndex.value = 5;
    });

    final double colNo = 60;
    final double colNama = 240;
    final double colEmail = 275;
    final double colRole = 200;
    final double colAksi = 170;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Row(
        children: [
          AdminSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kelola Akun User",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Manajemen data otentikasi hak akses dan informasi pengguna sistem langsung dari database.",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      TableSearchBar(
                        controller: ctrl.searchController,
                        hint: "Cari berdasarkan nama/email...",
                      ),
                      const Spacer(),
                      ToolbarButton(
                        title: "Tambah User",
                        icon: Icons.person_add_alt_1_rounded,
                        color: const Color(0xFF1E1E1E),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => InsertUserDialog(
                              onSave: (name, email, role, password) =>
                                  ctrl.createUser(
                                    name: name,
                                    email: email,
                                    role: role,
                                    password: password,
                                  ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      ToolbarButton(
                        title: "",
                        icon: Icons.refresh_outlined,
                        color: Colors.grey.shade400,
                        onTap: () => ctrl.fetchUsers(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Obx(() {
                        if (ctrl.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        }

                        final int startIndex =
                            (ctrl.currentPage.value - 1) * ctrl.itemsPerPage;
                        final int endIndex = startIndex + ctrl.itemsPerPage;

                        if (ctrl.filteredUsers.isEmpty) {
                          return const Center(
                            child: Text("Tidak ada data user ditemukan."),
                          );
                        }

                        final currentUsers = ctrl.filteredUsers.sublist(
                          startIndex,
                          endIndex > ctrl.filteredUsers.length
                              ? ctrl.filteredUsers.length
                              : endIndex,
                        );

                        final int totalPages =
                            (ctrl.filteredUsers.length / ctrl.itemsPerPage)
                                .ceil();

                        return Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  TableHeaderCell(title: "No", width: colNo),
                                  TableHeaderCell(
                                    title: "Nama Lengkap",
                                    width: colNama,
                                  ),
                                  TableHeaderCell(
                                    title: "Email",
                                    width: colEmail,
                                  ),
                                  TableHeaderCell(
                                    title: "Role / Hak Akses",
                                    width: colRole,
                                  ),
                                  TableHeaderCell(
                                    title: "Aksi",
                                    width: colAksi,
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    children: List.generate(currentUsers.length, (
                                      index,
                                    ) {
                                      final user = currentUsers[index];
                                      final bool isEven = index % 2 == 0;
                                      final rowBgColor = isEven
                                          ? Colors.white
                                          : const Color(0xFFF9FAFB);
                                      final int rowNumber =
                                          startIndex + index + 1;

                                      return Row(
                                        children: [
                                          TableRowCell(
                                            text: "$rowNumber",
                                            width: colNo,
                                            backgroundColor: rowBgColor,
                                          ),
                                          TableRowCell(
                                            text: user.name,
                                            width: colNama,
                                            backgroundColor: rowBgColor,
                                          ),
                                          TableRowCell(
                                            text: user.email,
                                            width: colEmail,
                                            backgroundColor: rowBgColor,
                                          ),
                                          TableRowCell(
                                            text: user.role,
                                            width: colRole,
                                            backgroundColor: rowBgColor,
                                          ),
                                          TableRowCell(
                                            text: "",
                                            width: colAksi,
                                            backgroundColor: rowBgColor,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TableActionButton(
                                                  icon: Icons.edit_outlined,
                                                  color: Colors.blue.shade700,
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          EditUserDialog(
                                                            currentUserData:
                                                                user.toJson(),
                                                            onSave:
                                                                (
                                                                  id,
                                                                  name,
                                                                  email,
                                                                  role,
                                                                ) => ctrl
                                                                    .updateUser(
                                                                      id: id,
                                                                      name:
                                                                          name,
                                                                      email:
                                                                          email,
                                                                      role:
                                                                          role,
                                                                    ),
                                                          ),
                                                    );
                                                  },
                                                ),
                                                const SizedBox(width: 8),
                                                TableActionButton(
                                                  icon:
                                                      Icons.lock_reset_rounded,
                                                  color: Colors.orange.shade700,
                                                  onTap: () {
                                                    if (user.id != null) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            ResetPasswordDialog(
                                                              userId: user.id!,
                                                              userName:
                                                                  user.name,
                                                              onSave:
                                                                  (
                                                                    id,
                                                                    newPassword,
                                                                  ) => ctrl.resetPassword(
                                                                    id: id,
                                                                    newPassword:
                                                                        newPassword,
                                                                  ),
                                                            ),
                                                      );
                                                    }
                                                  },
                                                ),
                                                const SizedBox(width: 8),
                                                TableActionButton(
                                                  icon: Icons
                                                      .delete_outline_rounded,
                                                  color: Colors.red.shade700,
                                                  onTap: () {
                                                    if (user.id != null) {
                                                      ctrl.deleteUser(user.id!);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),

                            TablePagination(
                              currentPage: ctrl.currentPage.value,
                              totalPages: totalPages == 0 ? 1 : totalPages,
                              onNext: () {
                                if (ctrl.currentPage.value < totalPages) {
                                  ctrl.currentPage.value++;
                                }
                              },
                              onPrevious: () {
                                if (ctrl.currentPage.value > 1)
                                  ctrl.currentPage.value--;
                              },
                              onPageSelected: (page) =>
                                  ctrl.currentPage.value = page,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
