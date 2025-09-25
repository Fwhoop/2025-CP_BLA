enum UserRole { user, admin, superadmin }

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;
  final String barangay;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.barangay,
    required this.createdAt,
  });

  bool get isAdmin => role == UserRole.admin || role == UserRole.superadmin;
  bool get isSuperAdmin => role == UserRole.superadmin;

  String get fullName => '$firstName $lastName';
  String get roleDisplay {
    switch (role) {
      case UserRole.superadmin:
        return 'Super Administrator';
      case UserRole.admin:
        return 'Administrator';
      case UserRole.user:
        return 'User';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.toString().split('.').last,
      'barangay': barangay,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: _getRoleFromString(json['role'] ?? 'user'),
      barangay: json['barangay'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  static UserRole _getRoleFromString(String roleString) {
    switch (roleString) {
      case 'admin':
        return UserRole.admin;
      case 'superadmin':
        return UserRole.superadmin;
      default:
        return UserRole.user;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User{id: $id, email: $email, name: $fullName, role: $role, barangay: $barangay}';
  }
}