class Supplier {
  final int? id;
  final String namaSupplier;
  final String? noHp;
  final String? alamat;

  Supplier({
    this.id,
    required this.namaSupplier,
    this.noHp,
    this.alamat,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      namaSupplier: json['nama_supplier'] ?? '',
      noHp: json['no_hp'],
      alamat: json['alamat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_supplier': namaSupplier,
      'no_hp': noHp,
      'alamat': alamat,
    };
  }

  Supplier copyWith({
    int? id,
    String? namaSupplier,
    String? noHp,
    String? alamat,
  }) {
    return Supplier(
      id: id ?? this.id,
      namaSupplier: namaSupplier ?? this.namaSupplier,
      noHp: noHp ?? this.noHp,
      alamat: alamat ?? this.alamat,
    );
  }
}
