// lib/views/mobile/kelola_resep_mobile_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/resep_table_controller.dart';
import 'package:tugas_akhir/widget/admin/mobile_admin_drawer.dart';
import 'package:tugas_akhir/widget/admin/resep/resep_pagination_footer.dart';
import 'package:tugas_akhir/widget/admin/resep/mobile/kelola_resep_mobile_list.dart';
import 'package:tugas_akhir/widget/admin/dialogs/resep/insert_resep_dialogs.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';

class KelolaResepMobilePage extends StatelessWidget {
  KelolaResepMobilePage({super.key});

  final ctrl = Get.find<ResepTableController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MobileAdminDrawer(),
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        // Judul teks diganti sepenuhnya dengan Search Bar
        title: TableSearchBar(
          controller: ctrl.searchC,
          hint: 'Cari resep aktif atau terhapus...',
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      bottomNavigationBar: ResepPaginationFooter(controller: ctrl),
      body: Column(
        children: [
          // KelolaResepMobileHeader dihapus dari sini karena seluruh fungsinya berpindah ke AppBar
          Expanded(child: KelolaResepMobileList(controller: ctrl)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => Get.dialog(InsertResepDialog()),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
