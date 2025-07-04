import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });
    // TODO: ตรวจสอบ username/password กับ backend
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
      if (_usernameController.text.trim().isEmpty ||
          _passwordController.text.isEmpty) {
        _errorText = 'กรุณากรอกข้อมูลให้ครบถ้วน';
      } else {
        // ไปหน้า home (mock)
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
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
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('/org');
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
                      controller: _usernameController,
                      enabled: !_isLoading,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: SunTheme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.95),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        errorText: _errorText,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: localizations.username,
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
                        fillColor: Colors.white.withOpacity(0.95),
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
                        suffixIcon: IconButton(
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
                      onPressed: _isLoading ? null : () {},
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
