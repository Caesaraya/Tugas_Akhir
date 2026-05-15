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
    // Debugging: cetak isi JSON jika Anda ragu apa nama key-nya
    // print("Isi JSON Resep: $json");

    return Resep(
      id: json['id'],
      namaResep: json['nama_resep'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      // Coba ganti 'bahan' dengan key yang sesuai dari API,
      // misal json['details'] atau json['resep_details'] jika 'bahan' tidak bekerja.
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
      // Perbaikan di sini: Gunakan helper function untuk handling String/Double
      jumlahBahan: _toDouble(json['jumlah_bahan']),
      namaBahan: json['nama_bahan'],
      merk: json['merk'],
      satuan: json['satuan'],
      hargaSatuan: _toDouble(json['harga_satuan']),
      totalHargaBahan: _toDouble(json['total_harga_bahan']),
    );
  }

  // Tambahkan helper function ini di luar class atau di dalam class sebagai static
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
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
