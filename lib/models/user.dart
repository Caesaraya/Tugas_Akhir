class User {
  final int? id;
  final String name;
  final String email;
  final String role;
  final String? password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.password,
  });

  // ========================
  // FROM JSON
  // ========================
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),

      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: _normalizeRole(json['role']),
      password: json['password']?.toString(),
    );
  }

  // ========================
  // TO JSON
  // ========================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': _normalizeRole(role),

      // password hanya dikirim kalau ada
      if (password != null) 'password': password,
    };
  }

  // ========================
  // COPY WITH
  // ========================
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      password: password ?? this.password,
    );
  }

  static String _normalizeRole(dynamic value) {
    return value?.toString().trim().toLowerCase() ?? '';
  }

  // ========================
  // ROLE CHECK
  // ========================
  bool get isAdmin => _normalizeRole(role) == "admin";

  bool get isKasir => _normalizeRole(role) == "kasir";

  bool get isOwner => _normalizeRole(role) == "owner";

  bool get isBakery => _normalizeRole(role) == "bakery";

  // ========================
  // DEBUG PRINT
  // ========================
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role)';
  }
}
