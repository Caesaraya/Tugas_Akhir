class HistoriStokModel {
  final DateTime tanggal;
  final int bahanBakuId;
  final String namaBahan;
  final double stokSebelum;
  final double stokSesudah;
  final double jumlahPenambahan;
  final double hargaSatuan;
  final double totalPengeluaran;

  HistoriStokModel({
    required this.tanggal,
    required this.bahanBakuId,
    required this.namaBahan,
    required this.stokSebelum,
    required this.stokSesudah,
    required this.jumlahPenambahan,
    required this.hargaSatuan,
    required this.totalPengeluaran,
  });

  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal.toIso8601String(),
      'bahan_baku_id': bahanBakuId,
      'nama_bahan': namaBahan,
      'stok_sebelum': stokSebelum,
      'stok_sesudah': stokSesudah,
      'jumlah_penambahan': jumlahPenambahan,
      'harga_satuan': hargaSatuan,
      'total_pengeluaran': totalPengeluaran,
    };
  }

  factory HistoriStokModel.fromJson(Map<String, dynamic> json) {
    return HistoriStokModel(
      tanggal: DateTime.parse(json['tanggal']),
      bahanBakuId: json['bahan_baku_id'] ?? 0,
      namaBahan: json['nama_bahan'] ?? '',
      stokSebelum: double.tryParse(json['stok_sebelum'].toString()) ?? 0.0,
      stokSesudah: double.tryParse(json['stok_sesudah'].toString()) ?? 0.0,
      jumlahPenambahan:
          double.tryParse(json['jumlah_penambahan'].toString()) ?? 0.0,
      hargaSatuan: double.tryParse(json['harga_satuan'].toString()) ?? 0.0,
      totalPengeluaran:
          double.tryParse(json['total_pengeluaran'].toString()) ?? 0.0,
    );
  }
}
