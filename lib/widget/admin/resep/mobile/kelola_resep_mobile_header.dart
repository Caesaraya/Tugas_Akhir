import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/resep_table_controller.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';
import 'package:tugas_akhir/widget/admin/table/table_toolbar.dart';
import 'package:tugas_akhir/page/admin/mobile/resep/resep_form_mobile_page.dart';

class KelolaResepMobileHeader extends StatelessWidget {
  final ResepTableController controller;

  const KelolaResepMobileHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TableSearchBar(
            controller: controller.searchC,
            hint: 'Cari resep...',
          ),
        ),
        const SizedBox(width: 10),
        ToolbarButton(
          icon: Icons.add,
          color: const Color(0xFF5D4037),
          onTap: () {
            controller.clearForm();
            Get.to(() => const ResepFormMobilePage(isEdit: false));
          },
        ),
      ],
    );
  }
}
