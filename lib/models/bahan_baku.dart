class BahanBaku {
  final int? id;
  final String namaBahan;
  final String merk;
  final String satuan;
  final double stok;
  final double hargaSatuan;
  final double? totalHarga;
  final DateTime? createdAt;
  final DateTime? deletedAt;

  BahanBaku({
    this.id,
    required this.namaBahan,
    required this.merk,
    required this.satuan,
    required this.stok,
    required this.hargaSatuan,
    this.totalHarga,
    this.createdAt,
    this.deletedAt,
  });
  factory BahanBaku.fromJson(Map<String, dynamic> json) {
    return BahanBaku(
      id: json['id'],
      namaBahan: json['nama_bahan'] ?? '',
      merk: json['merk'] ?? '',
      satuan: json['satuan'] ?? '',

      // Mengamankan Stok (Bisa menerima int, double, maupun string angka)
      stok: json['stok'] != null ? double.parse(json['stok'].toString()) : 0.0,

      // FIX: Mengamankan Harga Satuan dari String "17000.00"
      hargaSatuan: json['harga_satuan'] != null
          ? double.parse(json['harga_satuan'].toString())
          : 0.0,

      // FIX: Mengamankan Total Harga dari String
      totalHarga: json['total_harga'] != null
          ? double.parse(json['total_harga'].toString())
          : null,

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
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
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  BahanBaku copyWith({
    int? id,
    String? namaBahan,
    String? merk,
    String? satuan,
    double? stok, // DIUBAH: Menggunakan double
    double? hargaSatuan,
    double? totalHarga,
    DateTime? createdAt,
    DateTime? deletedAt,
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
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
