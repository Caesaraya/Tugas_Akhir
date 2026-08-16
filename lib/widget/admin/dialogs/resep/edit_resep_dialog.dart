import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import '../../../../controller/admin/resep_table_controller.dart';
import '../../../../models/resep.dart';
import '../custom_form_fields.dart';

class EditResepDialog extends StatefulWidget {
  final Resep resep;
  const EditResepDialog({super.key, required this.resep});

  @override
  State<EditResepDialog> createState() => _EditResepDialogState();
}

class _EditResepDialogState extends State<EditResepDialog> {
  final ctrl = Get.find<ResepTableController>();
  final bahanBakuCtrl = Get.find<BahanBakuTableController>();

  final TextEditingController _bahanDropdownC = TextEditingController();
  bool _submitted = false;

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

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ctrl.clearForm();
        }
      },
      child: Dialog(
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
                DialogCommonTitle(
                  title: 'Edit Formula Resep',
                  icon: Icons.edit_note_rounded,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                ),

                // --- FORM UTAMA ---
                CustomTextField(
                  controller: ctrl.namaResepC,
                  label: 'Nama Resep / Menu',
                  hint: 'Contoh: Roti Manis Premium',
                  icon: Icons.restaurant_menu_rounded,
                  width: double.infinity,
                  hasError: _submitted && ctrl.namaResepC.text.trim().isEmpty,
                  errorText: _submitted && ctrl.namaResepC.text.trim().isEmpty
                      ? 'Nama resep wajib diisi'
                      : null,
                  onChanged: (_) {
                    if (_submitted) setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: ctrl.deskripsiC,
                  label: 'Deskripsi / Catatan Produksi',
                  hint: 'Masukkan langkah singkat atau catatan porsi...',
                  icon: Icons.description_rounded,
                  width: double.infinity,
                  hasError: _submitted && ctrl.deskripsiC.text.trim().isEmpty,
                  errorText: _submitted && ctrl.deskripsiC.text.trim().isEmpty
                      ? 'Deskripsi wajib diisi'
                      : null,
                  onChanged: (_) {
                    if (_submitted) setState(() {});
                  },
                ),
                const SizedBox(height: 24),

                // --- SEKSI FORM INPUT BAHAN ---
                // --- RESPONSIF: Layout bahan menyesuaikan layar ---
                _buildAddBahanSection(isMobile),
                const SizedBox(height: 16),

                // --- DAFTAR BAHAN YANG SUDAH MASUK FORMULA ---
                const Text(
                  "Komposisi Formula Bahan Baku",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _themeColor,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTempBahanList(),
                const SizedBox(height: 28),

                // --- ACTION BUTTONS DIALOG ---
                // --- RESPONSIF: Tombol full-width di mobile ---
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSaveButton(),
                          const SizedBox(height: 8),
                          _buildCancelButton(),
                        ],
                      )
                    : DialogActionButtons(
                        saveLabel: 'Simpan Perubahan',
                        onCancel: () => Get.back(),
                        onSave: _onSave,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSave() {
    setState(() {
      _submitted = true;
    });

    final isTextValid =
        ctrl.namaResepC.text.trim().isNotEmpty &&
        ctrl.deskripsiC.text.trim().isNotEmpty;

    if (!isTextValid) {
      return;
    }

    if (ctrl.tempBahanList.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Semua data formulir wajib diisi dan tidak boleh menghapus semua bahan baku resep.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (widget.resep.id != null) {
      ctrl.updateResep(widget.resep.id!);
    } else {
      Get.snackbar(
        "Error",
        "ID Resep tidak ditemukan.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _themeColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: _onSave,
      child: const Text(
        'Simpan Perubahan',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () => Get.back(),
      child: const Text(
        'Batal',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAddBahanSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tambahkan Aturan Bahan Baku Baru",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // --- RESPONSIF: Di mobile susun vertikal, di desktop susun horizontal ---
          isMobile ? _buildAddBahanMobile() : _buildAddBahanDesktop(),
        ],
      ),
    );
  }

  // Layout horizontal (desktop) — sama persis dengan kode asli
  Widget _buildAddBahanDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Obx(() {
            final listOptions = bahanBakuCtrl.originalList
                .where((b) => b.deletedAt == null)
                .map((b) => "${b.id} - ${b.namaBahan} (${b.satuan})")
                .toList();
            return CustomDropdownMenu(
              controller: _bahanDropdownC,
              label: 'Pilih Bahan Baku',
              icon: Icons.search_rounded,
              items: listOptions,
            );
          }),
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
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: _buildTambahButton(),
        ),
      ],
    );
  }

  // Layout vertikal (mobile) — dropdown & field full-width, tombol di bawah
  Widget _buildAddBahanMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Obx(() {
          final listOptions = bahanBakuCtrl.originalList
              .where((b) => b.deletedAt == null)
              .map((b) => "${b.id} - ${b.namaBahan} (${b.satuan})")
              .toList();
          return CustomDropdownMenu(
            controller: _bahanDropdownC,
            label: 'Pilih Bahan Baku',
            icon: Icons.search_rounded,
            items: listOptions,
          );
        }),
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
        _buildTambahButton(fullWidth: true),
      ],
    );
  }

  Widget _buildTambahButton({bool fullWidth = false}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: _themeColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: fullWidth ? 16 : 16,
          vertical: fullWidth ? 14 : 20,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      icon: const Icon(Icons.add, size: 18),
      label: const Text(
        'Tambah',
        style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildTempBahanList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Obx(() {
        if (ctrl.tempBahanList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Belum ada bahan baku dalam resep ini.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: ctrl.tempBahanList.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: Color(0xFFF5F5F5)),
          itemBuilder: (context, index) {
            final item = ctrl.tempBahanList[index];
            String namaBahan = "Bahan #${item.bahanId}";

            try {
              final masterBahan = bahanBakuCtrl.originalList.firstWhere(
                (b) => b.id == item.bahanId,
              );
              namaBahan = "${masterBahan.namaBahan} (${masterBahan.satuan})";
            } catch (_) {
              namaBahan = item.namaBahan ?? namaBahan;
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
              subtitle: Text("Jumlah Kebutuhan: ${item.jumlahBahan}"),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
                onPressed: () => ctrl.removeBahanFromTempList(index),
              ),
            );
          },
        );
      }),
    );
  }
}
