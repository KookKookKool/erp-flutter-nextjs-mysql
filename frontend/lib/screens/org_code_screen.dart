import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/core/services/api_service.dart';

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

    final orgCode = _orgCodeController.text.trim();
    final localizations = AppLocalizations.of(context)!;

    if (orgCode.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorText = localizations.pleaseEnterOrgCode;
      });
      return;
    }

    if (orgCode.length < 4) {
      setState(() {
        _isLoading = false;
        _errorText = localizations.invalidOrgCode;
      });
      return;
    }

    try {
      // ตรวจสอบสถานะองค์กรกับ backend
      final result = await ApiService.getOrganizationStatus(orgCode);

      if (result['statusCode'] == 200) {
        final data = result['body'];

        if (data['status'] == 'APPROVED' && data['canLogin'] == true) {
          // Save org code to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('org_code', orgCode.toUpperCase());

          setState(() {
            _isLoading = false;
          });

          // ไปหน้า login
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        } else {
          setState(() {
            _isLoading = false;
            _errorText = data['message'] ?? localizations.orgNotApproved;
          });
        }
      } else if (result['statusCode'] == 404) {
        final error = result['body'];
        setState(() {
          _isLoading = false;
          _errorText = error['message'] ?? localizations.orgNotFound;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorText = localizations.orgCheckError;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = localizations.serverConnectionError;
      });
    }
  }

  void _registerOrg() {
    // ไปหน้าสมัครใช้งานองค์กรใหม่
    Navigator.of(context).pushNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          tooltip: localizations.back,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/language');
          },
        ),
      ),
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
                        fillColor: Colors.white.withValues(alpha: 0.95),
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
                      onSubmitted: (_) => _submit(),
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
