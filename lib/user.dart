class User {
  int? id;
  String name;
  String email;
  String? role;
  String? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    this.role,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'created_at': createdAt,
    };
  }

  Map<String, dynamic> toJsonForRegistration() {
    return {
      'name': name,
      'email': email,
      'password': 'default_password', // Ganti dengan input pengguna
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}