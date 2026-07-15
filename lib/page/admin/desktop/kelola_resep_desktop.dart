// lib/views/kelola_resep_desktop.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/controller/admin/resep_table_controller.dart';
import 'package:tugas_akhir/widget/admin/custom_sidebar.dart';
import 'package:tugas_akhir/widget/admin/dialogs/resep/insert_resep_dialogs.dart';
import 'package:tugas_akhir/widget/admin/resep/resep_table.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';
import 'package:tugas_akhir/widget/admin/table/table_toolbar.dart';

class KelolaResepDeskPage extends StatelessWidget {
  KelolaResepDeskPage({super.key});

  final ctrl = Get.find<ResepTableController>();

  @override
  Widget build(BuildContext context) {
    // Pindahkan mutasi Rx ke luar fase build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<NavigationController>().selectedIndex.value = 3;
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSidebar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kelola Resep',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manajemen formulasi resep takaran bahan baku pembuatan kue',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text(
                          "Daftar Resep",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        TableSearchBar(
                          controller: ctrl.searchC,
                          hint: 'Cari resep...',
                        ),
                        const SizedBox(width: 12),
                        ToolbarButton(
                          title: 'Insert Resep',
                          icon: Icons.add_rounded,
                          color: const Color(0xFF1E1E1E),
                          onTap: () {
                            Get.dialog(InsertResepDialog());
                          },
                        ),
                        const SizedBox(width: 12),
                        ToolbarButton(
                          title: "Refresh",
                          icon: Icons.refresh_outlined,
                          color: Colors.grey.shade400,
                          onTap: () {
                            ctrl.fetchData();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ResepTable(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
