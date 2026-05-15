// lib/views/mobile/kelola_resep_mobile_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/resep_table_controller.dart';
import 'package:tugas_akhir/widget/admin/mobile_admin_drawer.dart';
import 'package:tugas_akhir/widget/admin/resep/resep_pagination_footer.dart';
import 'package:tugas_akhir/widget/admin/resep/mobile/kelola_resep_mobile_header.dart';
import 'package:tugas_akhir/widget/admin/resep/mobile/kelola_resep_mobile_list.dart';

class KelolaResepMobilePage extends StatelessWidget {
  KelolaResepMobilePage({super.key});

  // Memastikan controller sudah ada
  final ctrl = Get.find<ResepTableController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MobileAdminDrawer(),
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Kelola Resep',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBar: ResepPaginationFooter(controller: ctrl),
      body: Column(
        children: [
          KelolaResepMobileHeader(controller: ctrl),
          const SizedBox(height: 12),
          Expanded(child: KelolaResepMobileList(controller: ctrl)),
        ],
      ),
    );
  }
}
