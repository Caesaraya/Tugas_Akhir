import 'package:flutter/material.dart';

class RumahLezaatTheme {
  static const Color primaryColor = Color(0xFFE65100);
  static const Color borderColor = Colors.black54;
}

/// 1. Komponen Input Teks Premium dengan Border Tebal (Fix Assertion Layout)
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String hint;
  final double width;
  final TextInputType keyboardType;
  final String? prefixText;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.hint,
    this.width = 440, // Default width jika tidak diatur manual
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    // Membungkus dengan SizedBox menggunakan parameter 'width' wajib dilakukan
    // agar aman saat dimasukkan ke dalam Row atau tata letak kompleks lainnya.
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,

          // Menggunakan widget Text mandiri untuk mencegah tabrakan asset dekorasi utama
          prefix: prefixText != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    prefixText!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                )
              : null,

          prefixIcon: Icon(icon, size: 22, color: Colors.black),
          labelStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 2.5),
          ),
        ),
      ),
    );
  }
}

/// 2. Komponen Dropdown Premium dengan Tombol Tambah Baru (+) jika Data Tidak Ada
class CustomDropdownField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String hint;
  final List<String> items;
  final Function(String) onAddNew;
  final double width;

  const CustomDropdownField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.hint,
    required this.items,
    required this.onAddNew,
    this.width = 440,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: DropdownButtonFormField<String>(
              value:
                  items.contains(controller.text) && controller.text.isNotEmpty
                  ? controller.text
                  : null,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                prefixIcon: Icon(icon, size: 22, color: Colors.black),
                labelStyle: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black, width: 2.5),
                ),
              ),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  controller.text = newValue;
                }
              },
              icon: const Icon(
                Icons.arrow_drop_down_rounded,
                size: 28,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                _showAddDialog(context);
              },
              icon: const Icon(Icons.add, size: 16),
              label: Text(
                'Tambah $label Baru',
                style: const TextStyle(fontSize: 12),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final TextEditingController newFieldC = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Tambah $label Baru',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: newFieldC,
          decoration: InputDecoration(
            hintText: 'Ketik nama $label baru...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (newFieldC.text.trim().isNotEmpty) {
                onAddNew(newFieldC.text.trim());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Tambah', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// 3. Komponen Switch Premium (Toggle Status)
class CustomSwitchField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;

  const CustomSwitchField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.width = 440,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.black,
            inactiveThumbColor: Colors.black54,
            inactiveTrackColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}

/// 4. Komponen Sepasang Tombol Aksi (Batal & Simpan) di Bawah Dialog
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black, width: 1.5),
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
