class Diskon {
  final int? id;
  final String namaDiskon;
  final double persenDiskon;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String status;

  Diskon({
    this.id,
    required this.namaDiskon,
    required this.persenDiskon,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.status,
  });

  factory Diskon.fromJson(Map<String, dynamic> json) {
    return Diskon(
      id: json['id'],
      namaDiskon: json['nama_diskon'] ?? '',
      persenDiskon: (json['persen_diskon'] ?? 0).toDouble(),
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      tanggalSelesai: DateTime.parse(json['tanggal_selesai']),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_diskon': namaDiskon,
      'persen_diskon': persenDiskon,
      'tanggal_mulai': tanggalMulai.toIso8601String().split('T')[0],
      'tanggal_selesai': tanggalSelesai.toIso8601String().split('T')[0],
      'status': status,
    };
  }

  Diskon copyWith({
    int? id,
    String? namaDiskon,
    double? persenDiskon,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? status,
  }) {
    return Diskon(
      id: id ?? this.id,
      namaDiskon: namaDiskon ?? this.namaDiskon,
      persenDiskon: persenDiskon ?? this.persenDiskon,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
      status: status ?? this.status,
    );
  }

  bool get isActive {
    final now = DateTime.now();
    return status.toUpperCase() == 'AKTIF' && 
           now.isAfter(tanggalMulai) && 
           now.isBefore(tanggalSelesai);
  }
}
