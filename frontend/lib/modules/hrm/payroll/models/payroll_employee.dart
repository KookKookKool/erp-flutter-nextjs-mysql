import 'package:equatable/equatable.dart';

enum PayrollType {
  daily('รายวัน'),
  monthly('รายเดือน');

  const PayrollType(this.displayName);
  final String displayName;
}

class PayrollEmployee extends Equatable {
  final String id;
  final String employeeId;
  final String firstName;
  final String lastName;
  final PayrollType payrollType;
  final double salary;
  final double socialSecurity;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PayrollEmployee({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.payrollType,
    required this.salary,
    required this.socialSecurity,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  PayrollEmployee copyWith({
    String? id,
    String? employeeId,
    String? firstName,
    String? lastName,
    PayrollType? payrollType,
    double? salary,
    double? socialSecurity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PayrollEmployee(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      payrollType: payrollType ?? this.payrollType,
      salary: salary ?? this.salary,
      socialSecurity: socialSecurity ?? this.socialSecurity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'firstName': firstName,
      'lastName': lastName,
      'payrollType': payrollType.name,
      'salary': salary,
      'socialSecurity': socialSecurity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PayrollEmployee.fromJson(Map<String, dynamic> json) {
    return PayrollEmployee(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      payrollType: PayrollType.values.firstWhere(
        (type) => type.name == json['payrollType'],
        orElse: () => PayrollType.monthly,
      ),
      salary: (json['salary'] as num).toDouble(),
      socialSecurity: (json['socialSecurity'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    employeeId,
    firstName,
    lastName,
    payrollType,
    salary,
    socialSecurity,
    createdAt,
    updatedAt,
  ];
}

class Employee {
  final String id;
  final String employeeId;
  final String firstName;
  final String lastName;

  const Employee({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }
}
