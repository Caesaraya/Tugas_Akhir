import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText; // ← Ditambahkan
  final Widget? suffixIcon; // ← Ditambahkan
  final ValueChanged<String>?
  onChanged; // ← Ditambahkan untuk mendeteksi perubahan input rupiah
  final bool hasError; // ← Ditambahkan untuk state error validasi
  final String? errorText; // ← Ditambahkan untuk pesan error validasi

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.hint,
    this.width = 440,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.inputFormatters,
    this.obscureText = false, // ← Ditambahkan (default false)
    this.suffixIcon, // ← Ditambahkan
    this.onChanged, // ← Ditambahkan
    this.hasError = false, // ← Ditambahkan (default false)
    this.errorText, // ← Ditambahkan (default null)
  });

  @override
  Widget build(BuildContext context) {
    // Auto-apply filter angka jika keyboardType adalah number
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
      inputFormatters: effectiveFormatters,
      obscureText: obscureText, // ← Ditambahkan ke TextField
      onChanged: onChanged, // ← Ditambahkan ke TextField
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        prefixIcon: Icon(
          icon,
          size: 22,
          color: hasError ? Colors.red : Colors.black,
        ),
        suffixIcon: suffixIcon, // ← Ditambahkan ke TextField
        errorText: errorText, // ← Ditambahkan untuk pesan error di bawah field
        labelStyle: TextStyle(
          color: hasError ? Colors.red : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: hasError ? Colors.red : RumahLezaatTheme.borderColor,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: hasError ? Colors.red : Colors.black,
            width: 2.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 2.5),
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
  final bool hasError; // ← Ditambahkan untuk state error validasi
  final String? errorText; // ← Ditambahkan untuk pesan error validasi

  const CustomDropdownMenu({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.items,
    this.width = 440,
    this.hasError = false, // ← Ditambahkan (default false)
    this.errorText, // ← Ditambahkan (default null)
  });

  @override
  Widget build(BuildContext context) {
    final Color normalBorderColor = hasError
        ? Colors.red
        : RumahLezaatTheme.borderColor;
    final Color focusedBorderColor = hasError ? Colors.red : Colors.black;
    final Color labelColor = hasError ? Colors.red : Colors.black87;
    final Color iconColor = hasError ? Colors.red : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu<String>(
          controller: controller,
          width: width,
          menuHeight: 200,
          label: Text(label, style: TextStyle(color: labelColor)),
          leadingIcon: Icon(icon, size: 22, color: iconColor),
          requestFocusOnTap: true,
          enableFilter: true,
          textStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          inputDecorationTheme: InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: normalBorderColor, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: focusedBorderColor, width: 2.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          dropdownMenuEntries: items
              .map((val) => DropdownMenuEntry<String>(value: val, label: val))
              .toList(),
        ),
        if (hasError && errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

/// 3. Komponen Stepper Stok Tambah / Kurang Dinamis (Mendukung int dan double)
class CustomStockStepper extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isDouble;
  final bool hasError; // ← Ditambahkan untuk state error validasi
  final String? errorText; // ← Ditambahkan untuk pesan error validasi

  const CustomStockStepper({
    super.key,
    required this.controller,
    this.label = 'Stok Produk',
    this.isDouble = false,
    this.hasError = false, // ← Ditambahkan (default false)
    this.errorText, // ← Ditambahkan (default null)
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = hasError
        ? Colors.red
        : RumahLezaatTheme.borderColor;
    final Color labelColor = hasError ? Colors.red : Colors.black87;
    final Color iconColor = hasError ? Colors.red : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '  $label',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 2.0),
          ),
          child: Row(
            children: [
              Icon(Icons.inventory_2_rounded, color: iconColor, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
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
        if (hasError && errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
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

/// 5. Komponen Header Dialog Judul + Icon (Responsible / Auto-wrap agar tidak overflow)
class DialogCommonTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const DialogCommonTitle({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black, size: 28),
        const SizedBox(width: 12),
        Expanded(
          // ← Membungkus judul dalam Expanded agar membungkus baris baru saat di mobile
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize:
                  20, // Menyesuaikan ukuran agar pas di layar handphone kecil
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
