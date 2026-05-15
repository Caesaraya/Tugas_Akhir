// lib/views/kelola_resep_desktop.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/controller/admin/resep_table_controller.dart';
import 'package:tugas_akhir/widget/admin/custom_drawer.dart';
import 'package:tugas_akhir/widget/admin/dialogs/resep/insert_resep_dialogs.dart';
// Ganti dengan path widget resep yang baru dibuat
import 'package:tugas_akhir/widget/admin/resep/resep_table.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';
import 'package:tugas_akhir/widget/admin/table/table_toolbar.dart';

class KelolaResepDeskPage extends StatelessWidget {
  KelolaResepDeskPage({super.key}) {
    Get.find<NavigationController>().selectedIndex.value = 2;
  }

  // Inisialisasi controller resep
  final ctrl = Get.find<ResepTableController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(), // Sesuai dengan referensi file
      appBar: AppBar(
        title: const Text('Kelola Resep - Rumah Lezzaaa'),
        backgroundColor: const Color(0xFF26C6DA), // Sesuai file
      ),
      backgroundColor: const Color(0xFFF4F6F9), // Sesuai file
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // Search bar untuk mencari resep
                TableSearchBar(controller: ctrl.searchC, hint: 'Cari resep...'),
                const SizedBox(width: 20),

                // Tombol Tambah Resep
                ToolbarButton(
                  title: 'Insert Resep',
                  icon: Icons.add,
                  color: Colors.cyan,
                  onTap: () {
                    Get.dialog(InsertResepDialog()); // Buat dialog ini nantinya
                  },
                ),
                const SizedBox(width: 12),

                // Tombol Refresh Data
                ToolbarButton(
                  title: "Refresh",
                  icon: Icons.refresh,
                  color: Colors.green,
                  onTap: () {
                    ctrl.fetchData();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Memanggil ResepTable yang baru dibuat
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ResepTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
