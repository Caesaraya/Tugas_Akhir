class Resep {
  final int? id;
  final String namaResep;
  final String deskripsi;
  final List<DetailResep>? bahan;
  final List<Map<String, dynamic>>? products;
  final DateTime? deletedAt;

  Resep({
    this.id,
    required this.namaResep,
    required this.deskripsi,
    this.bahan,
    this.products,
    this.deletedAt,
  });

  factory Resep.fromJson(Map<String, dynamic> json) {
    return Resep(
      id: json['id'],
      namaResep: json['nama_resep']?.toString() ?? '',
      deskripsi: json['deskripsi']?.toString() ?? '',
      bahan: json['bahan'] != null
          ? (json['bahan'] as List).map((e) => DetailResep.fromJson(e)).toList()
          : [],
      products: json['products'] != null
          ? (json['products'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList()
          : [],
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_resep': namaResep,
      'deskripsi': deskripsi,
      'bahan': bahan?.map((e) => e.toJson()).toList(),
      'products': products,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Resep copyWith({
    int? id,
    String? namaResep,
    String? deskripsi,
    List<DetailResep>? bahan,
    List<Map<String, dynamic>>? products,
    DateTime? deletedAt,
  }) {
    return Resep(
      id: id ?? this.id,
      namaResep: namaResep ?? this.namaResep,
      deskripsi: deskripsi ?? this.deskripsi,
      bahan: bahan ?? this.bahan,
      products: products ?? this.products,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

class DetailResep {
  final int? id;
  final int? resepId;
  final int bahanId;
  final double jumlahBahan;
  final String? namaBahan;
  final String? merk;
  final String? satuan;
  final double? hargaSatuan;
  final double? totalHargaBahan;

  DetailResep({
    this.id,
    this.resepId,
    required this.bahanId,
    required this.jumlahBahan,
    this.namaBahan,
    this.merk,
    this.satuan,
    this.hargaSatuan,
    this.totalHargaBahan,
  });

  factory DetailResep.fromJson(Map<String, dynamic> json) {
    return DetailResep(
      id: json['id'],
      resepId: json['resep_id'],
      // Amankan bahan_id agar jika Null dari backend otomatis menjadi 0
      bahanId: int.tryParse(json['bahan_id']?.toString() ?? '0') ?? 0,
      // Amankan jumlah_bahan terhadap nilai integer/double/null
      jumlahBahan:
          double.tryParse(json['jumlah_bahan']?.toString() ?? '0.0') ?? 0.0,
      namaBahan: json['nama_bahan']?.toString(),
      merk: json['merk']?.toString(),
      satuan: json['satuan']?.toString(),
      // Amankan field harga agar tidak crash jika backend mengirim tipe data campuran
      hargaSatuan: double.tryParse(json['harga_satuan']?.toString() ?? ''),
      totalHargaBahan: double.tryParse(
        json['total_harga_bahan']?.toString() ?? '',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resep_id': resepId,
      'bahan_id': bahanId,
      'jumlah_bahan': jumlahBahan,
      'nama_bahan': namaBahan,
      'merk': merk,
      'satuan': satuan,
      'harga_satuan': hargaSatuan,
      'total_harga_bahan': totalHargaBahan,
    };
  }
}
