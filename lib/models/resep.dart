class Resep {
  final int? id;
  final String namaResep;
  final String deskripsi;
  final List<DetailResep>? bahan;

  Resep({
    this.id,
    required this.namaResep,
    required this.deskripsi,
    this.bahan,
  });

  factory Resep.fromJson(Map<String, dynamic> json) {
    return Resep(
      id: json['id'],
      namaResep: json['nama_resep'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      bahan: json['bahan'] != null 
          ? (json['bahan'] as List).map((e) => DetailResep.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_resep': namaResep,
      'deskripsi': deskripsi,
      'bahan': bahan?.map((e) => e.toJson()).toList(),
    };
  }

  Resep copyWith({
    int? id,
    String? namaResep,
    String? deskripsi,
    List<DetailResep>? bahan,
  }) {
    return Resep(
      id: id ?? this.id,
      namaResep: namaResep ?? this.namaResep,
      deskripsi: deskripsi ?? this.deskripsi,
      bahan: bahan ?? this.bahan,
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
      bahanId: json['bahan_id'] ?? 0,
      jumlahBahan: (json['jumlah_bahan'] ?? 0).toDouble(),
      namaBahan: json['nama_bahan'],
      merk: json['merk'],
      satuan: json['satuan'],
      hargaSatuan: json['harga_satuan']?.toDouble(),
      totalHargaBahan: json['total_harga_bahan']?.toDouble(),
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

  DetailResep copyWith({
    int? id,
    int? resepId,
    int? bahanId,
    double? jumlahBahan,
    String? namaBahan,
    String? merk,
    String? satuan,
    double? hargaSatuan,
    double? totalHargaBahan,
  }) {
    return DetailResep(
      id: id ?? this.id,
      resepId: resepId ?? this.resepId,
      bahanId: bahanId ?? this.bahanId,
      jumlahBahan: jumlahBahan ?? this.jumlahBahan,
      namaBahan: namaBahan ?? this.namaBahan,
      merk: merk ?? this.merk,
      satuan: satuan ?? this.satuan,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      totalHargaBahan: totalHargaBahan ?? this.totalHargaBahan,
    );
  }
}
