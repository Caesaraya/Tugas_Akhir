class Produksi {
  final int? id;
  final int productId;
  final int jumlahProduksi;
  final DateTime tanggal;
  final String? productName;
  final String? jenis;
  final String? satuan;

  Produksi({
    this.id,
    required this.productId,
    required this.jumlahProduksi,
    required this.tanggal,
    this.productName,
    this.jenis,
    this.satuan,
  });

  factory Produksi.fromJson(Map<String, dynamic> json) {
    return Produksi(
      id: json['id'],
      productId: json['product_id'] ?? 0,
      jumlahProduksi: json['jumlah_produksi'] ?? 0,
      tanggal: json['tanggal'] != null 
          ? DateTime.parse(json['tanggal']) 
          : DateTime.now(),
      productName: json['name'],
      jenis: json['jenis'],
      satuan: json['satuan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'jumlah_produksi': jumlahProduksi,
      'tanggal': tanggal.toIso8601String(),
      'name': productName,
      'jenis': jenis,
      'satuan': satuan,
    };
  }

  Produksi copyWith({
    int? id,
    int? productId,
    int? jumlahProduksi,
    DateTime? tanggal,
    String? productName,
    String? jenis,
    String? satuan,
  }) {
    return Produksi(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      jumlahProduksi: jumlahProduksi ?? this.jumlahProduksi,
      tanggal: tanggal ?? this.tanggal,
      productName: productName ?? this.productName,
      jenis: jenis ?? this.jenis,
      satuan: satuan ?? this.satuan,
    );
  }
}
