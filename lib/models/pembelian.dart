class Pembelian {
  final int? id;
  final DateTime tanggal;
  final double total;
  final int supplierId;
  final String? namaSupplier;

  Pembelian({
    this.id,
    required this.tanggal,
    required this.total,
    required this.supplierId,
    this.namaSupplier,
  });

  factory Pembelian.fromJson(Map<String, dynamic> json) {
    return Pembelian(
      id: json['id'],
      tanggal: json['tanggal'] != null
          ? DateTime.parse(json['tanggal'])
          : DateTime.now(),
      total: json['total'] != null
          ? (json['total'] is String
                ? double.parse(json['total'])
                : (json['total'] as num).toDouble())
          : 0.0,
      supplierId: json['supplier_id'] ?? 0,
      namaSupplier: json['nama_supplier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String(),
      'total': total,
      'supplier_id': supplierId,
      'nama_supplier': namaSupplier,
    };
  }

  Pembelian copyWith({
    int? id,
    DateTime? tanggal,
    double? total,
    int? supplierId,
    String? namaSupplier,
  }) {
    return Pembelian(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      total: total ?? this.total,
      supplierId: supplierId ?? this.supplierId,
      namaSupplier: namaSupplier ?? this.namaSupplier,
    );
  }
}

class PembelianDetail {
  final int? id;
  final int pembelianId;
  final int bahanBakuId;
  final int jumlah;
  final double harga;
  final double subtotal;
  final String? namaBahan;
  final String? merk;
  final String? satuan;

  PembelianDetail({
    this.id,
    required this.pembelianId,
    required this.bahanBakuId,
    required this.jumlah,
    required this.harga,
    required this.subtotal,
    this.namaBahan,
    this.merk,
    this.satuan,
  });

  factory PembelianDetail.fromJson(Map<String, dynamic> json) {
    return PembelianDetail(
      id: json['id'],
      pembelianId: json['pembelian_id'] ?? 0,
      bahanBakuId: json['bahan_baku_id'] ?? 0,
      jumlah: json['jumlah'] ?? 0,
      harga: json['harga'] != null
          ? (json['harga'] is String
                ? double.parse(json['harga'])
                : (json['harga'] as num).toDouble())
          : 0.0,
      subtotal: json['subtotal'] != null
          ? (json['subtotal'] is String
                ? double.parse(json['subtotal'])
                : (json['subtotal'] as num).toDouble())
          : 0.0,
      namaBahan: json['nama_bahan'],
      merk: json['merk'],
      satuan: json['satuan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pembelian_id': pembelianId,
      'bahan_baku_id': bahanBakuId,
      'jumlah': jumlah,
      'harga': harga,
      'subtotal': subtotal,
      'nama_bahan': namaBahan,
      'merk': merk,
      'satuan': satuan,
    };
  }

  PembelianDetail copyWith({
    int? id,
    int? pembelianId,
    int? bahanBakuId,
    int? jumlah,
    double? harga,
    double? subtotal,
    String? namaBahan,
    String? merk,
    String? satuan,
  }) {
    return PembelianDetail(
      id: id ?? this.id,
      pembelianId: pembelianId ?? this.pembelianId,
      bahanBakuId: bahanBakuId ?? this.bahanBakuId,
      jumlah: jumlah ?? this.jumlah,
      harga: harga ?? this.harga,
      subtotal: subtotal ?? this.subtotal,
      namaBahan: namaBahan ?? this.namaBahan,
      merk: merk ?? this.merk,
      satuan: satuan ?? this.satuan,
    );
  }
}
