// lib/models/bahan_baku.dart
class BahanBaku {
  final int? id;
  final String namaBahan;
  final String merk;
  final String satuan;
  final int stok;
  final double hargaSatuan;
  final double? totalHarga;
  final DateTime? createdAt;

  BahanBaku({
    this.id,
    required this.namaBahan,
    required this.merk,
    required this.satuan,
    required this.stok,
    required this.hargaSatuan,
    this.totalHarga,
    this.createdAt,
  });

  factory BahanBaku.fromJson(Map<String, dynamic> json) {
    return BahanBaku(
      id: _parseInt(json['id']),
      namaBahan: json['nama_bahan']?.toString() ?? '',
      merk: json['merk']?.toString() ?? '',
      satuan: json['satuan']?.toString() ?? '',
      stok: _parseInt(json['stok']) ?? 0,
      hargaSatuan: _parseDouble(json['harga_satuan']) ?? 0.0,
      totalHarga: _parseDouble(json['total_harga']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_bahan': namaBahan,
      'merk': merk,
      'satuan': satuan,
      'stok': stok,
      'harga_satuan': hargaSatuan,
      'total_harga': totalHarga,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  BahanBaku copyWith({
    int? id,
    String? namaBahan,
    String? merk,
    String? satuan,
    int? stok,
    double? hargaSatuan,
    double? totalHarga,
    DateTime? createdAt,
  }) {
    return BahanBaku(
      id: id ?? this.id,
      namaBahan: namaBahan ?? this.namaBahan,
      merk: merk ?? this.merk,
      satuan: satuan ?? this.satuan,
      stok: stok ?? this.stok,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      totalHarga: totalHarga ?? this.totalHarga,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ── Safe parsers — menangani String, int, double, dan null sekaligus ───────
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
