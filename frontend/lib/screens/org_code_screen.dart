import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/core/theme/sun_theme.dart';

class OrgCodeScreen extends StatefulWidget {
  const OrgCodeScreen({super.key});

  @override
  State<OrgCodeScreen> createState() => _OrgCodeScreenState();
}

class _OrgCodeScreenState extends State<OrgCodeScreen> {
  final TextEditingController _orgCodeController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _orgCodeController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });
    // TODO: ตรวจสอบรหัสองค์กรกับ backend
    await Future.delayed(const Duration(seconds: 1));
    if (_orgCodeController.text.trim().isEmpty) {
      setState(() {
        _isLoading = false;
        _errorText = 'กรุณากรอกรหัสองค์กร';
      });
    } else if (_orgCodeController.text.trim().length < 4) {
      setState(() {
        _isLoading = false;
        _errorText = 'รหัสองค์กรไม่ถูกต้อง';
      });
    } else {
      // Save org code to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('org_code', _orgCodeController.text.trim());
      setState(() {
        _isLoading = false;
      });
      // ไปหน้า login
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _registerOrg() {
    // TODO: ไปหน้าสมัครใช้งานองค์กรใหม่
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ฟีเจอร์สมัครใช้งานองค์กรอยู่ระหว่างพัฒนา')),
    );
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
                    Text(
                      localizations.orgCodePrompt,
                      style: textTheme.displaySmall?.copyWith(
                        color: SunTheme.textOnGradient,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _orgCodeController,
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
                        labelText: localizations.orgCodeLabel,
                        labelStyle: textTheme.bodyMedium?.copyWith(
                          color: SunTheme.textSecondary,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                      ),
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
                        onPressed: _isLoading ? null : _submit,
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
                      onPressed: _isLoading ? null : _registerOrg,
                      child: Text(
                        localizations.registerOrg,
                        style: textTheme.bodyMedium?.copyWith(
                          color: SunTheme.sunDeepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
