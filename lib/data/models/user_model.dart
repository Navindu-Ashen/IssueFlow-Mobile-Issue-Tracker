import 'dart:convert';

class User {
  final String id;
  final String userName;
  final String email;
  final String contactNumber;
  final String role;
  // Note: Password shouldn't typically be sent to client, but keeping it per request requirements for mock auth.
  final String password;

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.contactNumber,
    required this.role,
    required this.password,
  });

  User copyWith({
    String? id,
    String? userName,
    String? email,
    String? contactNumber,
    String? role,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      contactNumber: contactNumber ?? this.contactNumber,
      role: role ?? this.role,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'contactNumber': contactNumber,
      'role': role,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      role: map['role'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
