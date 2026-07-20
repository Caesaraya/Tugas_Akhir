class TransactionModel {
  final int id;
  final String tanggal;
  final double totalHarga;
  final String metodePembayaran;

  TransactionModel({
    required this.id,
    required this.tanggal,
    required this.totalHarga,
    required this.metodePembayaran,
  });

  factory TransactionModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return TransactionModel(
        id: 0,
        tanggal: '',
        totalHarga: 0.0,
        metodePembayaran: '',
      );
    }
    return TransactionModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      tanggal: json['tanggal']?.toString() ?? '',
      totalHarga: double.tryParse(json['total_harga']?.toString() ?? '') ?? 0.0,
      metodePembayaran: json['metode_pembayaran']?.toString() ?? '',
    );
  }
}
