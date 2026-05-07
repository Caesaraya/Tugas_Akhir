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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      if (password != null) 'password': password,
    };
  }

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

  bool get isAdmin => role.toUpperCase() == 'ADMIN';
  bool get isKasir => role.toUpperCase() == 'KASIR';
  bool get isOwner => role.toUpperCase() == 'OWNER';
}