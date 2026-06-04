import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import '../../../../controller/admin/resep_table_controller.dart';
import '../custom_form_fields.dart';

class InsertResepDialog extends StatefulWidget {
  const InsertResepDialog({super.key});

  @override
  State<InsertResepDialog> createState() => _InsertResepDialogState();
}

class _InsertResepDialogState extends State<InsertResepDialog> {
  final ctrl = Get.find<ResepTableController>();
  final bahanBakuCtrl = Get.find<BahanBakuTableController>();

  final TextEditingController _bahanDropdownC = TextEditingController();

  static const Color _themeColor = Color(0xFF1E1E1E);

  @override
  void dispose() {
    _bahanDropdownC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- RESPONSIF: Deteksi lebar layar ---
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Dialog(
      // --- RESPONSIF: Sesuaikan inset agar dialog tidak terpotong di mobile ---
      insetPadding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
          : const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
      ),
      child: Container(
        // --- RESPONSIF: Lebar maksimum disesuaikan layar ---
        width: isMobile ? double.maxFinite : 800,
        // --- RESPONSIF: Batas tinggi agar scrollable di layar kecil ---
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DialogCommonTitle(
                title: 'Form Formulasi Resep',
                icon: Icons.bakery_dining_rounded,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
              ),
              CustomTextField(
                controller: ctrl.namaResepC,
                label: 'Nama Formulasi Resep',
                icon: Icons.dinner_dining_outlined,
                hint: 'Contoh: Resep Blackforest Base 22cm',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: ctrl.deskripsiC,
                label: 'Deskripsi / Instruksi Singkat',
                icon: Icons.description_outlined,
                hint: 'Masukkan keterangan resep produksi',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Divider(thickness: 1),
              ),
              const Text(
                'Tambah Komposisi Bahan Baku:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: _themeColor,
                ),
              ),
              const SizedBox(height: 12),
              // --- RESPONSIF: Seksi tambah bahan menyesuaikan layar ---
              _buildAddBahanSection(isMobile),
              const SizedBox(height: 20),
              const Text(
                'Daftar Bahan Terpilih di Resep ini:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: _themeColor,
                ),
              ),
              const SizedBox(height: 10),
              _buildTempBahanList(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(thickness: 1),
              ),
              // --- RESPONSIF: Tombol action menyesuaikan layar ---
              isMobile ? _buildMobileActions() : _buildDesktopActions(),
            ],
          ),
        ),
      ),
    );
  }

  // Tombol aksi vertikal full-width untuk mobile
  Widget _buildMobileActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _themeColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _onSave,
          child: const Text(
            'Simpan Formula Resep',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            ctrl.clearForm();
            Get.back();
          },
          child: const Text(
            'Batal',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Tombol aksi horizontal untuk desktop (sama persis dengan kode asli)
  Widget _buildDesktopActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            ctrl.clearForm();
            Get.back();
          },
          child: const Text(
            'Batal',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _themeColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _onSave,
          child: const Text(
            'Simpan Formula Resep',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _onSave() {
    if (ctrl.namaResepC.text.trim().isEmpty ||
        ctrl.deskripsiC.text.trim().isEmpty ||
        ctrl.tempBahanList.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Semua data formulir wajib diisi dan minimal 1 takaran bahan harus dimasukkan.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    ctrl.submitResep();
  }

  Widget _buildAddBahanSection(bool isMobile) {
    return Obx(() {
      if (bahanBakuCtrl.originalList.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Memuat data bahan baku atau data kosong...',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        );
      }

      final List<String> itemsBahan = bahanBakuCtrl.originalList
          .map((b) => "${b.id} - ${b.namaBahan} (${b.satuan})")
          .toList();

      // --- RESPONSIF: Di mobile susun vertikal, di desktop susun horizontal ---
      return isMobile
          ? _buildAddBahanMobile(itemsBahan)
          : _buildAddBahanDesktop(itemsBahan);
    });
  }

  // Layout vertikal (mobile) — semua field full-width
  Widget _buildAddBahanMobile(List<String> itemsBahan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomDropdownMenu(
          controller: _bahanDropdownC,
          label: 'Pilih Bahan Baku Utama',
          icon: Icons.compost_outlined,
          items: itemsBahan,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: ctrl.jumlahBahanC,
          label: 'Takaran Kebutuhan',
          icon: Icons.scale_outlined,
          hint: '0.0',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
        ),
        const SizedBox(height: 10),
        _buildTambahkanButton(fullWidth: true),
      ],
    );
  }

  // Layout horizontal (desktop) — sama persis dengan kode asli
  Widget _buildAddBahanDesktop(List<String> itemsBahan) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: CustomDropdownMenu(
            controller: _bahanDropdownC,
            label: 'Pilih Bahan Baku Utama',
            icon: Icons.compost_outlined,
            items: itemsBahan,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: CustomTextField(
            controller: ctrl.jumlahBahanC,
            label: 'Takaran Kebutuhan',
            icon: Icons.scale_outlined,
            hint: '0.0',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildTambahkanButton(),
      ],
    );
  }

  Widget _buildTambahkanButton({bool fullWidth = false}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF5F5F5),
        foregroundColor: _themeColor,
        elevation: 0,
        side: BorderSide(color: Colors.grey.shade300),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: fullWidth ? 14 : 18,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        if (_bahanDropdownC.text.isEmpty) {
          Get.snackbar("Peringatan", "Pilih bahan baku terlebih dahulu.");
          return;
        }
        final String val = _bahanDropdownC.text;
        final String rawId = val.split(' - ')[0];
        final int? idBahan = num.tryParse(rawId)?.toInt();

        if (idBahan == null) {
          Get.snackbar("Error", "Format ID Bahan baku tidak valid.");
          return;
        }

        ctrl.selectedBahanId.value = idBahan;
        ctrl.addBahanToTempList();
        _bahanDropdownC.clear();
      },
      icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
      label: const Text(
        'Tambahkan',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTempBahanList() {
    return Obx(() {
      if (ctrl.tempBahanList.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              style: BorderStyle.solid,
            ),
          ),
          child: const Center(
            child: Text(
              'Belum ada bahan baku yang dimasukkan ke formula resep ini.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        );
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ctrl.tempBahanList.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
        itemBuilder: (context, index) {
          final item = ctrl.tempBahanList[index];

          final String namaBahan;
          final String satuanBahan;

          if (bahanBakuCtrl.originalList.any((b) => b.id == item.bahanId)) {
            final masterBahan = bahanBakuCtrl.originalList.firstWhere(
              (b) => b.id == item.bahanId,
            );
            namaBahan = masterBahan.namaBahan;
            satuanBahan = masterBahan.satuan;
          } else {
            namaBahan = item.namaBahan ?? "Bahan #${item.bahanId}";
            satuanBahan = "";
          }

          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFF5F5F5),
              child: Icon(Icons.restaurant_menu_rounded, color: _themeColor),
            ),
            title: Text(
              namaBahan,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              satuanBahan.isNotEmpty
                  ? "Kebutuhan: ${item.jumlahBahan} $satuanBahan"
                  : "Kebutuhan: ${item.jumlahBahan}",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: () => ctrl.removeBahanFromTempList(index),
            ),
          );
        },
      );
    });
  }
}
