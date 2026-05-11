// lib/views/widgets/bahan_baku/bahan_baku_form_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_controller.dart';
import 'package:tugas_akhir/models/bahan_baku.dart';
import 'package:tugas_akhir/widget/admin/bahan/bahan_baku_form_field.dart';

class BahanBakuFormDialog extends StatefulWidget {
  const BahanBakuFormDialog({super.key, this.existing});

  /// Jika null → mode Tambah; jika tidak null → mode Edit
  final BahanBaku? existing;

  @override
  State<BahanBakuFormDialog> createState() => _BahanBakuFormDialogState();
}

class _BahanBakuFormDialogState extends State<BahanBakuFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaBahanCtrl;
  late final TextEditingController _merkCtrl;
  late final TextEditingController _satuanCtrl;
  late final TextEditingController _stokCtrl;
  late final TextEditingController _hargaCtrl;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _namaBahanCtrl = TextEditingController(text: e?.namaBahan ?? '');
    _merkCtrl = TextEditingController(text: e?.merk ?? '');
    _satuanCtrl = TextEditingController(text: e?.satuan ?? '');
    _stokCtrl = TextEditingController(text: e != null ? '${e.stok}' : '');
    _hargaCtrl = TextEditingController(
      text: e != null ? e.hargaSatuan.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _namaBahanCtrl.dispose();
    _merkCtrl.dispose();
    _satuanCtrl.dispose();
    _stokCtrl.dispose();
    _hargaCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<BahanBakuController>();

    final payload = BahanBaku(
      id: widget.existing?.id,
      namaBahan: _namaBahanCtrl.text.trim(),
      merk: _merkCtrl.text.trim(),
      satuan: _satuanCtrl.text.trim(),
      stok: int.parse(_stokCtrl.text.trim()),
      hargaSatuan: double.parse(_hargaCtrl.text.trim()),
    );

    final bool ok;
    if (_isEdit) {
      ok = await controller.updateBahanBaku(payload);
    } else {
      ok = await controller.create(payload);
    }

    if (ok && mounted) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BahanBakuController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF2196F3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(
                    _isEdit ? Icons.edit_outlined : Icons.add_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isEdit ? 'Edit Bahan Baku' : 'Tambah Bahan Baku',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // ── Form ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Row 1: Nama Bahan + Merk
                    Row(
                      children: [
                        Expanded(
                          child: BahanBakuFormField(
                            label: 'Nama Bahan',
                            controller: _namaBahanCtrl,
                            hint: 'contoh: Tepung Terigu',
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Wajib diisi'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: BahanBakuFormField(
                            label: 'Merk',
                            controller: _merkCtrl,
                            hint: 'contoh: Segitiga Biru',
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Wajib diisi'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Row 2: Satuan + Stok
                    Row(
                      children: [
                        Expanded(
                          child: BahanBakuFormField(
                            label: 'Satuan',
                            controller: _satuanCtrl,
                            hint: 'contoh: kg, liter, pcs',
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Wajib diisi'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: BahanBakuFormField(
                            label: 'Stok',
                            controller: _stokCtrl,
                            hint: '0',
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Wajib diisi';
                              }
                              if (int.tryParse(v.trim()) == null) {
                                return 'Harus angka bulat';
                              }
                              if (int.parse(v.trim()) < 0) {
                                return 'Tidak boleh negatif';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Harga Satuan
                    BahanBakuFormField(
                      label: 'Harga Satuan (Rp)',
                      controller: _hargaCtrl,
                      hint: 'contoh: 15000',
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                        if (double.tryParse(v.trim()) == null) {
                          return 'Harus angka';
                        }
                        if (double.parse(v.trim()) < 0) {
                          return 'Tidak boleh negatif';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ── Actions ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => ElevatedButton.icon(
                      onPressed: controller.isSaving.value ? null : _save,
                      icon: controller.isSaving.value
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              _isEdit ? Icons.save_outlined : Icons.add,
                              size: 16,
                            ),
                      label: Text(_isEdit ? 'Simpan' : 'Tambah'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
