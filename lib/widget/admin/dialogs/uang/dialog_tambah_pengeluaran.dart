import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/keuangan_controller.dart';
import 'package:tugas_akhir/models/expense_category.dart';
import 'package:tugas_akhir/utils/app_color.dart';
import 'package:tugas_akhir/widget/admin/dialogs/custom_form_fields.dart';

class DialogTambahPengeluaran extends StatefulWidget {
  const DialogTambahPengeluaran({super.key});

  @override
  State<DialogTambahPengeluaran> createState() =>
      _DialogTambahPengeluaranState();
}

class _DialogTambahPengeluaranState extends State<DialogTambahPengeluaran> {
  final _controller = Get.find<KeuanganController>();
  final _formKey = GlobalKey<FormState>();

  final _categoryController =
      TextEditingController(); // Controller untuk melacak ketikan kategori
  final _nominalController = TextEditingController();
  final _keteranganController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  ExpenseCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (_controller.listCategories.isNotEmpty) {
      // Hilangkan kategori Bahan Baku dari dropdown input manual agar tidak ganda
      final manualCats = _controller.listCategories
          .where((c) => c.name != 'Bahan Baku')
          .toList();
      if (manualCats.isNotEmpty) {
        _selectedCategory = manualCats.first;
        _categoryController.text =
            _selectedCategory!.name; // Set text awal dropdown
      }
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _nominalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manualCategories = _controller.listCategories
        .where((c) => c.name != 'Bahan Baku')
        .toList();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const DialogCommonTitle(
        title: 'Tambah Pengeluaran',
        icon: Icons.add_card_rounded,
        
      ),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Field Tanggal
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Tanggal: ${DateFormat('dd MMMM yyyy').format(_selectedDate)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.calendar_month,
                    color: AppColors  .black,
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                ),
                const SizedBox(height: 12),

                // Dropdown Kategori Bisa Diketik & Filter Otomatis
                FormField<String>(
                  validator: (value) {
                    if (_categoryController.text.trim().isEmpty) {
                      return 'Kategori wajib diisi atau dipilih';
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> fieldState) {
                    return DropdownMenu<ExpenseCategory>(
                      controller: _categoryController,
                      expandedInsets: EdgeInsets
                          .zero, // Membuat lebar penuh & responsif mengikuti dialog
                      enableFilter:
                          true, // Mengaktifkan fitur pencarian/ketik langsung
                      requestFocusOnTap: true,
                      label: const Text('Kategori Pengeluaran'),
                      inputDecorationTheme: InputDecorationTheme(
                        labelStyle: const TextStyle(fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      initialSelection: _selectedCategory,
                      onSelected: (ExpenseCategory? value) {
                        setState(() {
                          _selectedCategory = value;
                          if (value != null) {
                            fieldState.didChange(value.name);
                          }
                        });
                      },
                      dropdownMenuEntries: manualCategories.map((cat) {
                        return DropdownMenuEntry<ExpenseCategory>(
                          value: cat,
                          label: cat.name,
                          style: MenuItemButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Custom Input Nominal
                CustomTextField(
                  controller: _nominalController,
                  label: 'Nominal Pengeluaran (Rp)',
                  icon: Icons.payments_outlined,
                  hint: 'Masukkan nominal tanpa titik/koma',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Custom Input Keterangan
                CustomTextField(
                  controller: _keteranganController,
                  label: 'Keterangan (Opsional)',
                  icon: Icons.description_outlined,
                  hint: 'Contoh: Pembayaran WiFi bulanan toko',
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        DialogActionButtons(
          onSave: () async {
            if (_formKey.currentState!.validate()) {
              String inputCategoryName = _categoryController.text.trim();
              int? targetCategoryId;

              // 1. Cek apakah kategori yang diketik sudah ada di database (Case Insensitive)
              ExpenseCategory? existingCat;
              for (var cat in _controller.listCategories) {
                if (cat.name.toLowerCase() == inputCategoryName.toLowerCase()) {
                  existingCat = cat;
                  break;
                }
              }

              if (existingCat != null) {
                // Gunakan ID kategori yang sudah ada
                targetCategoryId = existingCat.id;
              } else {
                // 2. Jika ketikan user baru, buat kategori baru terlebih dahulu ke database via API
                targetCategoryId = await _controller.tambahKategoriBaru(
                  inputCategoryName,
                );
              }

              // Jika gagal mendapatkan ID kategori (baik lama maupun baru), batalkan proses
              if (targetCategoryId == null) {
                Get.snackbar(
                  'Gagal',
                  'Kategori gagal diproses atau API Kategori Belum Siap',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              // 3. Simpan Transaksi Pengeluarannya
              double nominalVal =
                  double.tryParse(_nominalController.text) ?? 0.0;
              String formattedDate = DateFormat(
                'yyyy-MM-dd',
              ).format(_selectedDate);

              bool success = await _controller.tambahPengeluaranManual(
                tanggal: formattedDate,
                categoryId: targetCategoryId,
                nominal: nominalVal,
                keterangan: _keteranganController.text,
              );

              if (success) {
                Get.back();
                Get.snackbar(
                  'Sukses',
                  'Pengeluaran manual berhasil disimpan ke database',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            }
          },
          saveLabel: 'Simpan',
          onCancel: () {
            Get.back();
          },
        ),
      ],
    );
  }
}
