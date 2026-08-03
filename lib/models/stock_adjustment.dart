class StockAdjustment {
  final int? id;
  final String localId;
  final int productId;
  final int oldStock;
  final int newStock;
  final int difference;
  final String reason;
  final String? note;
  final int createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? productName;
  final String? userName;

  StockAdjustment({
    this.id,
    required this.localId,
    required this.productId,
    required this.oldStock,
    required this.newStock,
    required this.difference,
    required this.reason,
    this.note,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.productName,
    this.userName,
  });

  factory StockAdjustment.fromJson(Map<String, dynamic> json) {
    return StockAdjustment(
      id: json['id'],
      localId: json['local_id'],
      productId: json['product_id'],
      oldStock: json['old_stock'],
      newStock: json['new_stock'],
      difference: json['difference'],
      reason: json['reason'],
      note: json['note'],
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      productName: json['product_name'],
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'local_id': localId,
      'product_id': productId,
      'old_stock': oldStock,
      'new_stock': newStock,
      'difference': difference,
      'reason': reason,
      'note': note,
      'created_by': createdBy,
    };
  }
}
