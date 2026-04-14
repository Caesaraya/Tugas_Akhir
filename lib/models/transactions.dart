class TransactionModel {
  final int id;
  final String tanggal;
  final double totalHarga;

  TransactionModel({
    required this.id,
    required this.tanggal,
    required this.totalHarga,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0, // 🔥 WAJIB ADA INI
      tanggal: json['tanggal'] ?? '',
      totalHarga: double.tryParse(json['total_harga'].toString()) ?? 0,
    );
  }
}