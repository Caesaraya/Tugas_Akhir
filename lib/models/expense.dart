class Expense {
  final int id;
  final String tanggal;
  final int categoryId;
  final String categoryName;
  final double nominal;
  final String? keterangan;
  final String? createdAt;

  Expense({
    required this.id,
    required this.tanggal,
    required this.categoryId,
    required this.categoryName,
    required this.nominal,
    this.keterangan,
    this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: int.tryParse(json['id'].toString()) ?? 0,
      tanggal: json['tanggal'] ?? '',
      categoryId: int.tryParse(json['category_id'].toString()) ?? 0,
      categoryName: json['category_name'] ?? '',
      nominal: double.tryParse(json['nominal'].toString()) ?? 0.0,
      keterangan: json['keterangan'],
      createdAt: json['created_at'],
    );
  }

  Expense copyWith({
    int? id,
    String? tanggal,
    int? categoryId,
    String? categoryName,
    double? nominal,
    String? keterangan,
    String? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      nominal: nominal ?? this.nominal,
      keterangan: keterangan ?? this.keterangan,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal,
      'category_id': categoryId,
      'category_name': categoryName,
      'nominal': nominal,
      'keterangan': keterangan,
      'created_at': createdAt,
    };
  }
}

class ExpenseSummary {
  final String categoryName;
  final double totalNominal;
  final int totalCount;
  final double grandTotal;

  ExpenseSummary({
    required this.categoryName,
    required this.totalNominal,
    required this.totalCount,
    required this.grandTotal,
  });

  factory ExpenseSummary.fromJson(Map<String, dynamic> json) {
    return ExpenseSummary(
      categoryName: json['category_name'] ?? '',
      totalNominal: double.tryParse(json['total_nominal'].toString()) ?? 0.0,
      totalCount: int.tryParse(json['total_count'].toString()) ?? 0,
      grandTotal: double.tryParse(json['grand_total'].toString()) ?? 0.0,
    );
  }

  ExpenseSummary copyWith({
    String? categoryName,
    double? totalNominal,
    int? totalCount,
    double? grandTotal,
  }) {
    return ExpenseSummary(
      categoryName: categoryName ?? this.categoryName,
      totalNominal: totalNominal ?? this.totalNominal,
      totalCount: totalCount ?? this.totalCount,
      grandTotal: grandTotal ?? this.grandTotal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_name': categoryName,
      'total_nominal': totalNominal,
      'total_count': totalCount,
      'grand_total': grandTotal,
    };
  }
}
