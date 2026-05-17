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

      // otomatis uppercase biar aman
      role: json['role']?.toString().toUpperCase() ?? '',

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
      'role': role,

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

  bool get isValid {
    final emailPattern = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    return name.isNotEmpty && emailPattern.hasMatch(email) && role.isNotEmpty;
  }

  // ========================
  // ROLE CHECK
  // ========================
  bool get isAdmin => role == "ADMIN";

  bool get isKasir => role == "KASIR";

  bool get isOwner => role == "OWNER";

  // ========================
  // DEBUG PRINT
  // ========================
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role)';
  }
}
