import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ← TAMBAHAN

class RumahLezaatTheme {
  static const Color primaryColor = Color(0xFFE65100);
  static const Color borderColor = Colors.black54;
}

/// 1. Komponen Input Teks Premium dengan Border Tebal
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String hint;
  final double width;
  final TextInputType keyboardType;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters; // ← TAMBAHAN

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.hint,
    this.width = 440,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.inputFormatters, // ← TAMBAHAN
  });

  @override
  Widget build(BuildContext context) {
    // ← TAMBAHAN: Auto-apply filter angka jika keyboardType adalah number
    final List<TextInputFormatter> effectiveFormatters =
        inputFormatters ??
        (keyboardType == TextInputType.number ||
                keyboardType ==
                    const TextInputType.numberWithOptions(decimal: false) ||
                keyboardType ==
                    const TextInputType.numberWithOptions(signed: false) ||
                keyboardType ==
                    const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    )
            ? [FilteringTextInputFormatter.digitsOnly]
            : []);

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: effectiveFormatters, // ← TAMBAHAN
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        prefixIcon: Icon(icon, size: 22, color: Colors.black),
        labelStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: RumahLezaatTheme.borderColor,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black, width: 2.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

/// 2. Komponen Dropdown Menu Premium & Scrollable
class CustomDropdownMenu extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final List<String> items;
  final double width;

  const CustomDropdownMenu({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.items,
    this.width = 440,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      controller: controller,
      width: width,
      menuHeight: 200,
      label: Text(label),
      leadingIcon: Icon(icon, size: 22, color: Colors.black),
      requestFocusOnTap: true,
      enableFilter: true,
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: RumahLezaatTheme.borderColor,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black, width: 2.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      dropdownMenuEntries: items
          .map((val) => DropdownMenuEntry<String>(value: val, label: val))
          .toList(),
    );
  }
}

/// 3. Komponen Stepper Stok Tambah / Kurang Dinamis (Mendukung int dan double)
class CustomStockStepper extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isDouble;

  const CustomStockStepper({
    super.key,
    required this.controller,
    this.label = 'Stok Produk',
    this.isDouble = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '  $label',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: RumahLezaatTheme.borderColor, width: 2.0),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.inventory_2_rounded,
                color: Colors.black,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  // ← TAMBAHAN: Filter sesuai tipe (int atau double)
                  inputFormatters: isDouble
                      ? [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ]
                      : [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (isDouble) {
                          double current =
                              double.tryParse(controller.text) ?? 0.0;
                          if (current > 0) {
                            double res = current - 1;
                            controller.text = res % 1 == 0
                                ? res.toInt().toString()
                                : res.toString();
                          }
                        } else {
                          int current = int.tryParse(controller.text) ?? 0;
                          if (current > 0) {
                            controller.text = (current - 1).toString();
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                    Container(
                      width: 1.5,
                      height: 24,
                      color: Colors.grey.shade300,
                    ),
                    IconButton(
                      onPressed: () {
                        if (isDouble) {
                          double current =
                              double.tryParse(controller.text) ?? 0.0;
                          double res = current + 1;
                          controller.text = res % 1 == 0
                              ? res.toInt().toString()
                              : res.toString();
                        } else {
                          int current = int.tryParse(controller.text) ?? 0;
                          controller.text = (current + 1).toString();
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 4. Komponen Sepasang Button Aksi (Batal & Simpan)
class DialogActionButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String saveLabel;

  const DialogActionButtons({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.saveLabel = 'Simpan',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: const BorderSide(color: Colors.grey, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Batal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              saveLabel,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}

/// 5. Komponen Header Dialog Judul + Icon
class DialogCommonTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const DialogCommonTitle({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black, size: 28),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
