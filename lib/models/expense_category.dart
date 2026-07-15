class ExpenseCategory {
  final int id;
  final String name;
  final String? description;
  final String? createdAt;

  ExpenseCategory({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      createdAt: json['created_at'],
    );
  }

  ExpenseCategory copyWith({
    int? id,
    String? name,
    String? description,
    String? createdAt,
  }) {
    return ExpenseCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
    };
  }
}
