class BahanBaku {
  final int? id;
  final String namaBahan;
  final String merk;
  final String satuan;
  final double stok;
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
    // Fungsi kecil untuk mengubah apapun (String/int/double) menjadi double
    double castToDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return BahanBaku(
      id: json['id'],
      namaBahan: json['nama_bahan'] ?? '',
      merk: json['merk'] ?? '',
      satuan: json['satuan'] ?? '',

      // Gunakan fungsi bantuan tadi untuk semua field angka
      stok: castToDouble(json['stok']),
      hargaSatuan: castToDouble(json['harga_satuan']),
      totalHarga: json['total_harga'] != null
          ? castToDouble(json['total_harga'])
          : null,

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
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
    double? stok,
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
}
