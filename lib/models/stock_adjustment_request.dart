class StockAdjustmentRequest {
  final int? id;
  final int productId;
  final String productName;
  final int userId;
  final String userName;
  final int oldStock;
  final int newStock;
  final String reason;
  final String status;
  final int? approvedBy;
  final String? approvedByName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StockAdjustmentRequest({
    this.id,
    required this.productId,
    required this.productName,
    required this.userId,
    required this.userName,
    required this.oldStock,
    required this.newStock,
    required this.reason,
    required this.status,
    this.approvedBy,
    this.approvedByName,
    this.createdAt,
    this.updatedAt,
  });

  factory StockAdjustmentRequest.fromJson(Map<String, dynamic> json) {
    return StockAdjustmentRequest(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'] ?? '',
      userId: json['user_id'],
      userName: json['user_name'] ?? '',
      oldStock: json['old_stock'],
      newStock: json['new_stock'],
      reason: json['reason'] ?? '',
      status: json['status'] ?? 'pending',
      approvedBy: json['approved_by'],
      approvedByName: json['approved_by_name'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'user_id': userId,
      'user_name': userName,
      'old_stock': oldStock,
      'new_stock': newStock,
      'reason': reason,
      'status': status,
      'approved_by': approvedBy,
      'approved_by_name': approvedByName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  StockAdjustmentRequest copyWith({
    int? id,
    int? productId,
    String? productName,
    int? userId,
    String? userName,
    int? oldStock,
    int? newStock,
    String? reason,
    String? status,
    int? approvedBy,
    String? approvedByName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StockAdjustmentRequest(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      oldStock: oldStock ?? this.oldStock,
      newStock: newStock ?? this.newStock,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedByName: approvedByName ?? this.approvedByName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}