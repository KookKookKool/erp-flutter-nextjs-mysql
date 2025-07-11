class Employee {
  final String id;
  final String employeeId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String position;
  final String department;
  final String level;
  final DateTime startDate;
  final bool isActive;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Employee({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.position,
    required this.department,
    required this.level,
    required this.startDate,
    required this.isActive,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      position: json['position'] ?? '',
      department: json['department'] ?? '',
      level: json['level'] ?? '',
      startDate: DateTime.parse(
        json['start_date'] ?? DateTime.now().toIso8601String(),
      ),
      isActive: json['is_active'] ?? true,
      profileImage: json['profile_image'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'position': position,
      'department': department,
      'level': level,
      'start_date': startDate.toIso8601String(),
      'is_active': isActive,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class EmployeeLoginResponse {
  final String token;
  final Employee employee;
  final Map<String, dynamic> organization;
  final Map<String, dynamic> permissions;

  EmployeeLoginResponse({
    required this.token,
    required this.employee,
    required this.organization,
    required this.permissions,
  });

  factory EmployeeLoginResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeLoginResponse(
      token: json['token'] ?? '',
      employee: Employee.fromJson(json['employee'] ?? {}),
      organization: json['organization'] ?? {},
      permissions: json['permissions'] ?? {},
    );
  }
}
