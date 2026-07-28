import 'package:flutter/material.dart';

class BayarButton extends StatelessWidget {
  final bool hasFoto;
  final bool sudahKonfirmasi;
  final bool isLoading;
  final VoidCallback? onPressed;

  const BayarButton({
    super.key,
    required this.hasFoto,
    required this.sudahKonfirmasi,
    required this.isLoading,
    required this.onPressed,
  });

  String get _label {
    if (!hasFoto) return 'Pilih Foto Bukti Dahulu';
    if (!sudahKonfirmasi) return 'Konfirmasi Bukti Dahulu';
    return 'Bayar Sekarang';
  }

  @override
  Widget build(BuildContext context) {
    final aktif = hasFoto && sudahKonfirmasi;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                _label,
                style: TextStyle(
                  color: aktif ? Colors.green : Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}