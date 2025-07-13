import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/core/auth/services/employee_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/core/services/api_service.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? _orgCode;

  @override
  void initState() {
    super.initState();
    _loadOrgCodeAndSavedData();
  }

  Future<void> _loadOrgCodeAndSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgCode = prefs.getString('org_code');
      final savedEmployeeId = prefs.getString('saved_employee_id');
      if (savedEmployeeId != null) {
        _employeeIdController.text = savedEmployeeId;
        _rememberMe = true;
      }
    });
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final localizations = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final employeeId = _employeeIdController.text.trim();
    final password = _passwordController.text;

    if (employeeId.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorText = localizations.pleaseEnterAllFields;
      });
      return;
    }

    if (_orgCode == null || _orgCode!.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorText = localizations.orgCodeNotFound;
      });
      return;
    }

    try {
      // ใช้ Employee Auth Service โดยใช้ baseUrl จาก ApiService เพื่อรองรับทุก platform
      final authService = EmployeeAuthService(baseUrl: ApiService.baseUrl);
      final result = await authService.loginWithEmployeeId(
        orgCode: _orgCode!,
        employeeId: employeeId,
        password: password,
      );

      if (result['statusCode'] == 200) {
        final data = result['body'];

        // Save login data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['token']);
        await prefs.setString('employee_data', json.encode(data['employee']));
        await prefs.setString('org_data', json.encode(data['organization']));
        await prefs.setString(
          'permissions',
          json.encode(data['permissions'] ?? {}),
        );
        await prefs.setString('login_type', 'employee');

        if (_rememberMe) {
          await prefs.setString('saved_employee_id', employeeId);
        } else {
          await prefs.remove('saved_employee_id');
        }

        setState(() {
          _isLoading = false;
        });

        // ลบข้อมูลหน้าเดิมที่เคยเข้าไว้ เพื่อให้ login ใหม่ไปหน้า home เสมอ
        await prefs.remove('last_visited_route');

        // ไปหน้า home
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        final error = result['body'];
        setState(() {
          _isLoading = false;
          _errorText = error['error'] ?? localizations.serverConnectionError;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = localizations.serverConnectionError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final content = Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? constraints.maxWidth * 0.25 : 32.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: SunTheme.sunDeepOrange,
                          ),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (mounted) {
                                    Navigator.of(
                                      context,
                                    ).pushReplacementNamed('/org');
                                  }
                                },
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizations.login,
                      style: textTheme.displaySmall?.copyWith(
                        color: SunTheme.textOnGradient,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _employeeIdController,
                      enabled: !_isLoading,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: SunTheme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.95),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        errorText: _errorText,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: localizations.employeeCodeOrEmail,
                        labelStyle: textTheme.bodyMedium?.copyWith(
                          color: SunTheme.textSecondary,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: SunTheme.sunOrange,
                            width: 2,
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.badge_outlined,
                          color: SunTheme.sunDeepOrange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      enabled: !_isLoading,
                      obscureText: _obscurePassword,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: SunTheme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.95),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        errorText: _errorText,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: localizations.password,
                        labelStyle: textTheme.bodyMedium?.copyWith(
                          color: SunTheme.textSecondary,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: SunTheme.sunOrange,
                            width: 2,
                          ),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: SunTheme.sunDeepOrange,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_errorText != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorText!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: SunTheme.textSecondary,
                          ),
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: SunTheme.textSecondary,
                            checkColor: Colors.white,
                            onChanged: _isLoading
                                ? null
                                : (val) {
                                    setState(() {
                                      _rememberMe = val ?? false;
                                    });
                                  },
                          ),
                        ),
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () {
                                  setState(() {
                                    _rememberMe = !_rememberMe;
                                  });
                                },
                          child: Text(
                            localizations.rememberMe,
                            style: textTheme.bodyMedium?.copyWith(
                              color: SunTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SunTheme.sunOrange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                localizations.login,
                                style: textTheme.labelLarge,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(localizations.forgotPassword),
                                  content: Text(
                                    localizations.forgotPasswordDialogContent,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('ตกลง'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      child: Text(
                        localizations.forgotPassword,
                        style: textTheme.bodyMedium?.copyWith(
                          color: SunTheme.sunDeepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          );
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(gradient: SunTheme.sunGradient),
            child: content,
          );
        },
      ),
    );
  }
}
