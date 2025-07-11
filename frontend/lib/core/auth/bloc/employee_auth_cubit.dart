import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/auth/models/employee_model.dart';
import 'package:frontend/core/auth/services/employee_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class EmployeeAuthState {}

class EmployeeAuthInitial extends EmployeeAuthState {}

class EmployeeAuthLoading extends EmployeeAuthState {}

class EmployeeAuthSuccess extends EmployeeAuthState {
  final EmployeeLoginResponse loginResponse;

  EmployeeAuthSuccess({required this.loginResponse});
}

class EmployeeAuthError extends EmployeeAuthState {
  final String message;

  EmployeeAuthError({required this.message});
}

class EmployeeProfileLoaded extends EmployeeAuthState {
  final Employee employee;

  EmployeeProfileLoaded({required this.employee});
}

class EmployeeAuthCubit extends Cubit<EmployeeAuthState> {
  final EmployeeAuthService _authService;

  EmployeeAuthCubit(this._authService) : super(EmployeeAuthInitial());

  Future<void> loginWithEmployeeId({
    required String orgCode,
    required String employeeId,
    required String password,
    bool rememberMe = false,
  }) async {
    emit(EmployeeAuthLoading());

    try {
      final result = await _authService.loginWithEmployeeId(
        orgCode: orgCode,
        employeeId: employeeId,
        password: password,
      );

      if (result['statusCode'] == 200) {
        final loginResponse = EmployeeLoginResponse.fromJson(result['body']);

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', loginResponse.token);
        await prefs.setString(
          'employee_data',
          json.encode(loginResponse.employee.toJson()),
        );
        await prefs.setString(
          'org_data',
          json.encode(loginResponse.organization),
        );
        await prefs.setString(
          'permissions',
          json.encode(loginResponse.permissions),
        );
        await prefs.setString('org_code', orgCode);
        await prefs.setString('login_type', 'employee');

        if (rememberMe) {
          await prefs.setString('saved_employee_id', employeeId);
        } else {
          await prefs.remove('saved_employee_id');
        }

        emit(EmployeeAuthSuccess(loginResponse: loginResponse));
      } else {
        final error = result['body'];
        emit(
          EmployeeAuthError(
            message: error['error'] ?? 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ',
          ),
        );
      }
    } catch (e) {
      emit(
        EmployeeAuthError(
          message: 'เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์: $e',
        ),
      );
    }
  }

  Future<void> fetchEmployeeProfile({
    required String orgCode,
    required String employeeId,
    required String token,
  }) async {
    emit(EmployeeAuthLoading());

    try {
      final result = await _authService.fetchEmployeeProfile(
        orgCode: orgCode,
        employeeId: employeeId,
        token: token,
      );

      if (result['statusCode'] == 200) {
        final employee = Employee.fromJson(result['body']['employee']);
        emit(EmployeeProfileLoaded(employee: employee));
      } else {
        final error = result['body'];
        emit(
          EmployeeAuthError(
            message: error['error'] ?? 'ไม่สามารถโหลดข้อมูลพนักงานได้',
          ),
        );
      }
    } catch (e) {
      emit(EmployeeAuthError(message: 'เกิดข้อผิดพลาดในการโหลดข้อมูล: $e'));
    }
  }

  Future<bool> checkStoredAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final employeeData = prefs.getString('employee_data');
      final orgData = prefs.getString('org_data');
      final permissions = prefs.getString('permissions');
      final loginType = prefs.getString('login_type');

      if (token != null &&
          employeeData != null &&
          orgData != null &&
          permissions != null &&
          loginType == 'employee') {
        final employee = Employee.fromJson(json.decode(employeeData));
        final organization = json.decode(orgData);
        final userPermissions = json.decode(permissions);

        final loginResponse = EmployeeLoginResponse(
          token: token,
          employee: employee,
          organization: organization,
          permissions: userPermissions,
        );

        emit(EmployeeAuthSuccess(loginResponse: loginResponse));
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getSavedEmployeeId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('saved_employee_id');
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('employee_data');
      await prefs.remove('org_data');
      await prefs.remove('permissions');
      await prefs.remove('login_type');
      // Keep org_code and saved_employee_id for convenience

      emit(EmployeeAuthInitial());
    } catch (e) {
      emit(EmployeeAuthError(message: 'เกิดข้อผิดพลาดในการออกจากระบบ'));
    }
  }

  bool hasPermission(String module, String subModule, String permission) {
    final currentState = state;
    if (currentState is EmployeeAuthSuccess) {
      final permissions = currentState.loginResponse.permissions;
      try {
        final modulePerms = permissions[module] as Map<String, dynamic>?;
        if (modulePerms == null) return false;

        final subModulePerms = modulePerms[subModule] as Map<String, dynamic>?;
        if (subModulePerms == null) return false;

        return subModulePerms[permission] == true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  Employee? getCurrentEmployee() {
    final currentState = state;
    if (currentState is EmployeeAuthSuccess) {
      return currentState.loginResponse.employee;
    }
    return null;
  }

  Map<String, dynamic>? getCurrentOrganization() {
    final currentState = state;
    if (currentState is EmployeeAuthSuccess) {
      return currentState.loginResponse.organization;
    }
    return null;
  }
}
