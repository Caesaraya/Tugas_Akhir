import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/user_controller.dart';
import 'package:tugas_akhir/widget/admin/mobile_admin_drawer.dart';
import 'package:tugas_akhir/widget/admin/dialogs/user/user_dialogs.dart';

class KelolaUserMobilePage extends StatelessWidget {
  KelolaUserMobilePage({super.key});

  final ctrl = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Kelola User',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh_rounded),
        //     onPressed: () => ctrl.fetchUsers(),
        //   ),
        // ],
      ),
      drawer: const MobileAdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                child: TextField(
                  controller: ctrl.searchController,
                  decoration: InputDecoration(
                    hintText: "Cari nama atau role...",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }

                if (ctrl.filteredUsers.isEmpty) {
                  return const Center(child: Text("Tidak ada data pengguna."));
                }

                return ListView.builder(
                  itemCount: ctrl.filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = ctrl.filteredUsers[index];

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    user.role,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),

                            Row(
                              children: [
                                const Icon(
                                  Icons.email_outlined,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Email: ",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    user.email,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            Wrap(
                              alignment: WrapAlignment.end,
                              spacing: 4,
                              runSpacing: 4,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    "Ubah",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.blue.shade700,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => EditUserDialog(
                                        currentUserData: user.toJson(),
                                        onSave: (id, name, email, role) =>
                                            ctrl.updateUser(
                                              id: id,
                                              name: name,
                                              email: email,
                                              role: role,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                TextButton.icon(
                                  icon: const Icon(
                                    Icons.lock_reset_rounded,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    "Reset",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.orange.shade700,
                                  ),
                                  onPressed: () {
                                    if (user.id != null) {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ResetPasswordDialog(
                                              userId: user.id!,
                                              userName: user.name,
                                              onSave: (id, newPassword) =>
                                                  ctrl.resetPassword(
                                                    id: id,
                                                    newPassword: newPassword,
                                                  ),
                                            ),
                                      );
                                    }
                                  },
                                ),
                                TextButton.icon(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    "Hapus",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red.shade700,
                                  ),
                                  onPressed: () {
                                    if (user.id != null) {
                                      ctrl.deleteUser(user.id!);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => InsertUserDialog(
              onSave: (name, email, role, password) => ctrl.createUser(
                name: name,
                email: email,
                role: role,
                password: password,
              ),
            ),
          );
        },
        child: const Icon(Icons.person_add_alt_1_rounded),
      ),
    );
  }
}
