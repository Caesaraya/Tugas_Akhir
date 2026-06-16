class BahanBakuRequirement {
  final int bahanId;
  final String namaBahan;
  final String? merk;
  final String satuan;
  final int stokTersedia;
  final int hargaSatuan;
  final int kebutuhanPerProduk;
  final int totalDibutuhkan;
  final int sisaStok;
  final bool cukup;
  final int kekurangan;

  BahanBakuRequirement({
    required this.bahanId,
    required this.namaBahan,
    this.merk,
    required this.satuan,
    required this.stokTersedia,
    required this.hargaSatuan,
    required this.kebutuhanPerProduk,
    required this.totalDibutuhkan,
    required this.sisaStok,
    required this.cukup,
    required this.kekurangan,
  });

  factory BahanBakuRequirement.fromJson(Map<String, dynamic> json) {
    return BahanBakuRequirement(
      bahanId: int.tryParse(json['bahan_id'].toString()) ?? 0,
      namaBahan: json['nama_bahan'] ?? '',
      merk: json['merk'],
      satuan: json['satuan'] ?? '',
      stokTersedia: int.tryParse(json['stok_tersedia'].toString()) ?? 0,
      hargaSatuan: int.tryParse(json['harga_satuan'].toString()) ?? 0,
      kebutuhanPerProduk: int.tryParse(json['kebutuhan_per_produk'].toString()) ?? 0,
      totalDibutuhkan: int.tryParse(json['total_dibutuhkan'].toString()) ?? 0,
      sisaStok: int.tryParse(json['sisa_stok'].toString()) ?? 0,
      cukup: json['cukup'] == 1 || json['cukup'] == true,
      kekurangan: int.tryParse(json['kekurangan'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bahan_id': bahanId,
      'nama_bahan': namaBahan,
      'merk': merk,
      'satuan': satuan,
      'stok_tersedia': stokTersedia,
      'harga_satuan': hargaSatuan,
      'kebutuhan_per_produk': kebutuhanPerProduk,
      'total_dibutuhkan': totalDibutuhkan,
      'sisa_stok': sisaStok,
      'cukup': cukup ? 1 : 0,
      'kekurangan': kekurangan,
    };
  }
}

class BakeryCalculationResult {
  final int produkId;
  final int quantity;
  final List<BahanBakuRequirement> bahan;
  final int totalBiaya;
  final bool semuaBahanCukup;

  BakeryCalculationResult({
    required this.produkId,
    required this.quantity,
    required this.bahan,
    required this.totalBiaya,
    required this.semuaBahanCukup,
  });

  factory BakeryCalculationResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    
    return BakeryCalculationResult(
      produkId: int.tryParse(data['produk_id'].toString()) ?? 0,
      quantity: int.tryParse(data['quantity'].toString()) ?? 0,
      bahan: (data['bahan'] as List?)
              ?.map((e) => BahanBakuRequirement.fromJson(e))
              .toList() ??
          [],
      totalBiaya: int.tryParse(data['total_biaya'].toString()) ?? 0,
      semuaBahanCukup: data['semua_bahan_cukup'] == true || data['semua_bahan_cukup'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produk_id': produkId,
      'quantity': quantity,
      'bahan': bahan.map((e) => e.toJson()).toList(),
      'total_biaya': totalBiaya,
      'semua_bahan_cukup': semuaBahanCukup ? 1 : 0,
    };
  }
}

class BakeryAvailabilityResult {
  final int produkId;
  final int quantity;
  final bool semuaBahanCukup;
  final int totalBahan;
  final int bahanCukup;
  final int bahanKurang;

  BakeryAvailabilityResult({
    required this.produkId,
    required this.quantity,
    required this.semuaBahanCukup,
    required this.totalBahan,
    required this.bahanCukup,
    required this.bahanKurang,
  });

  factory BakeryAvailabilityResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    
    return BakeryAvailabilityResult(
      produkId: int.tryParse(data['produk_id'].toString()) ?? 0,
      quantity: int.tryParse(data['quantity'].toString()) ?? 0,
      semuaBahanCukup: data['semua_bahan_cukup'] == true || data['semua_bahan_cukup'] == 1,
      totalBahan: int.tryParse(data['total_bahan'].toString()) ?? 0,
      bahanCukup: int.tryParse(data['bahan_cukup'].toString()) ?? 0,
      bahanKurang: int.tryParse(data['bahan_kurang'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produk_id': produkId,
      'quantity': quantity,
      'semua_bahan_cukup': semuaBahanCukup ? 1 : 0,
      'total_bahan': totalBahan,
      'bahan_cukup': bahanCukup,
      'bahan_kurang': bahanKurang,
    };
  }
}

class BakeryCostResult {
  final int produkId;
  final int quantity;
  final int totalBiaya;

  BakeryCostResult({
    required this.produkId,
    required this.quantity,
    required this.totalBiaya,
  });

  factory BakeryCostResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    
    return BakeryCostResult(
      produkId: int.tryParse(data['produk_id'].toString()) ?? 0,
      quantity: int.tryParse(data['quantity'].toString()) ?? 0,
      totalBiaya: int.tryParse(data['total_biaya'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produk_id': produkId,
      'quantity': quantity,
      'total_biaya': totalBiaya,
    };
  }
}

class ProduksiPossibleItem {
  final int produkId;
  final String produkNama;
  final String jenis;
  final String satuan;
  final int stokProduk;
  final int totalBahanDibutuhkan;
  final bool bisaDiproduksi;
  final int quantity;

  ProduksiPossibleItem({
    required this.produkId,
    required this.produkNama,
    required this.jenis,
    required this.satuan,
    required this.stokProduk,
    required this.totalBahanDibutuhkan,
    required this.bisaDiproduksi,
    required this.quantity,
  });

  factory ProduksiPossibleItem.fromJson(Map<String, dynamic> json) {
    return ProduksiPossibleItem(
      produkId: int.tryParse(json['produk_id'].toString()) ?? 0,
      produkNama: json['produk_nama'] ?? '',
      jenis: json['jenis'] ?? '',
      satuan: json['satuan'] ?? '',
      stokProduk: int.tryParse(json['stok_produk'].toString()) ?? 0,
      totalBahanDibutuhkan: int.tryParse(json['total_bahan_dibutuhkan'].toString()) ?? 0,
      bisaDiproduksi: json['bisa_diproduksi'] == true || json['bisa_diproduksi'] == 1,
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produk_id': produkId,
      'produk_nama': produkNama,
      'jenis': jenis,
      'satuan': satuan,
      'stok_produk': stokProduk,
      'total_bahan_dibutuhkan': totalBahanDibutuhkan,
      'bisa_diproduksi': bisaDiproduksi ? 1 : 0,
      'quantity': quantity,
    };
  }
}

class BahanUsageResult {
  final int totalDigunakan;
  final List<Map<String, dynamic>> resep;

  BahanUsageResult({
    required this.totalDigunakan,
    required this.resep,
  });

  factory BahanUsageResult.fromJson(Map<String, dynamic> json) {
    return BahanUsageResult(
      totalDigunakan: int.tryParse(json['total_digunakan'].toString()) ?? 0,
      resep: (json['resep'] as List?)?.map((e) => e as Map<String, dynamic>).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_digunakan': totalDigunakan,
      'resep': resep,
    };
  }
}

class StockSummaryResult {
  final int totalBahan;
  final int totalStok;
  final int totalNilai;

  StockSummaryResult({
    required this.totalBahan,
    required this.totalStok,
    required this.totalNilai,
  });

  factory StockSummaryResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return StockSummaryResult(
      totalBahan: int.tryParse(data['total_bahan'].toString()) ?? 0,
      totalStok: int.tryParse(data['total_stok'].toString()) ?? 0,
      totalNilai: int.tryParse(data['total_nilai'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_bahan': totalBahan,
      'total_stok': totalStok,
      'total_nilai': totalNilai,
    };
  }
}