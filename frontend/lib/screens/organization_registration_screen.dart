import 'package:flutter/material.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/services/api_service.dart';

class OrganizationRegistrationScreen extends StatefulWidget {
  const OrganizationRegistrationScreen({super.key});

  @override
  State<OrganizationRegistrationScreen> createState() =>
      _OrganizationRegistrationScreenState();
}

class _OrganizationRegistrationScreenState
    extends State<OrganizationRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  // Organization Info Controllers
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _orgCodeController = TextEditingController();
  final TextEditingController _orgEmailController = TextEditingController();
  final TextEditingController _orgPhoneController = TextEditingController();
  final TextEditingController _orgAddressController = TextEditingController();
  final TextEditingController _orgDescriptionController =
      TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _companyRegistrationNumberController =
      TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();

  // Business Info
  String _selectedBusinessType = '';
  String _selectedEmployeeCount = '';

  // Admin Info Controllers
  final TextEditingController _adminNameController = TextEditingController();
  final TextEditingController _adminEmailController = TextEditingController(
    text: 'admin@sunerp.com',
  );
  final TextEditingController _adminPasswordController = TextEditingController(
    text: '123456',
  );
  final TextEditingController _confirmPasswordController =
      TextEditingController(text: '123456');

  @override
  void initState() {
    super.initState();
    _generateOrgCode(); // Generate initial org code
  }

  @override
  void dispose() {
    _orgNameController.dispose();
    _orgCodeController.dispose();
    _orgEmailController.dispose();
    _orgPhoneController.dispose();
    _orgAddressController.dispose();
    _orgDescriptionController.dispose();
    _websiteController.dispose();
    _companyRegistrationNumberController.dispose();
    _taxIdController.dispose();
    _adminNameController.dispose();
    _adminEmailController.dispose();
    _adminPasswordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0) {
      // Validate form before proceeding
      if (_formKey.currentState!.validate() && _validateOrgInfo()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentPage == 1) {
      // Validate form before proceeding
      if (_formKey.currentState!.validate() && _validateAdminInfo()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validateOrgInfo() {
    return _orgNameController.text.isNotEmpty &&
        _orgCodeController.text.isNotEmpty &&
        _orgEmailController.text.isNotEmpty &&
        _orgPhoneController.text.isNotEmpty &&
        _orgAddressController.text.isNotEmpty &&
        _companyRegistrationNumberController.text.isNotEmpty &&
        _taxIdController.text.isNotEmpty &&
        _selectedBusinessType.isNotEmpty &&
        _selectedEmployeeCount.isNotEmpty;
  }

  bool _validateAdminInfo() {
    return _adminNameController.text.isNotEmpty &&
        _adminEmailController.text.isNotEmpty &&
        _adminPasswordController.text.isNotEmpty &&
        _adminPasswordController.text == _confirmPasswordController.text &&
        _adminPasswordController.text.length >= 6;
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // ส่งเฉพาะรายละเอียดที่กรอก ไม่รวมข้อมูลอื่น
      final description = _orgDescriptionController.text.trim();

      final result = await ApiService.registerOrganization(
        orgName: _orgNameController.text.trim(),
        orgCode: _orgCodeController.text.trim(),
        orgEmail: _orgEmailController.text.trim(),
        orgPhone: _orgPhoneController.text.trim(),
        orgAddress: _orgAddressController.text.trim(),
        orgDescription: description,
        companyRegistrationNumber: _companyRegistrationNumberController.text
            .trim(),
        taxId: _taxIdController.text.trim(),
        businessType: _selectedBusinessType,
        employeeCount: _selectedEmployeeCount,
        website: _websiteController.text.trim(),
        adminName: _adminNameController.text.trim(),
        adminEmail: _adminEmailController.text.trim(),
        adminPassword: _adminPasswordController.text,
      );

      print('Registration result: $result'); // Debug

      if (result['statusCode'] == 200) {
        final data = result['body'];
        if (mounted) {
          _showSuccessDialog(data['message'], data['orgCode']);
        }
      } else {
        final error = result['body'];
        if (mounted) {
          _showErrorDialog(
            error['error'] ??
                error['message'] ??
                (AppLocalizations.of(context)?.registrationError ??
                    'Registration error occurred'),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(
          '${AppLocalizations.of(context)?.serverConnectionErrorDetail ?? 'Server connection error'}: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog(String message, String orgCode) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(localizations.success),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            Text(message),
            const SizedBox(height: 8),
            Text(
              '${localizations.orgCodeLabel}: $orgCode',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(
                context,
              ).pushReplacementNamed('/org'); // Go to org code screen
            },
            child: Text(localizations.ok),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.ok),
          ),
        ],
      ),
    );
  }

  // Generate organization code automatically
  void _generateOrgCode() {
    // org_ + timestamp + random 3 digits
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (100 + (timestamp % 900)).toString();
    final orgCode = 'org_${timestamp}_$random';
    _orgCodeController.text = orgCode;
  }

  String _getBusinessTypeLabel(String value) {
    final localizations = AppLocalizations.of(context);
    switch (value) {
      case 'RETAIL':
        return localizations?.businessTypeRetailTh ?? 'Retail';
      case 'WHOLESALE':
        return localizations?.businessTypeWholesaleTh ?? 'Wholesale';
      case 'MANUFACTURING':
        return localizations?.businessTypeManufacturingTh ?? 'Manufacturing';
      case 'SERVICE':
        return localizations?.businessTypeServiceTh ?? 'Service';
      case 'TECHNOLOGY':
        return localizations?.businessTypeTechnologyTh ?? 'Technology';
      case 'EDUCATION':
        return localizations?.businessTypeEducationTh ?? 'Education';
      case 'HEALTHCARE':
        return localizations?.businessTypeHealthcareTh ?? 'Healthcare';
      case 'FINANCE':
        return localizations?.businessTypeFinanceTh ?? 'Finance';
      case 'CONSTRUCTION':
        return localizations?.businessTypeConstructionTh ?? 'Construction';
      case 'FOOD':
        return localizations?.businessTypeFoodTh ?? 'Food & Beverage';
      case 'LOGISTICS':
        return localizations?.businessTypeLogisticsTh ?? 'Logistics';
      case 'TOURISM':
        return localizations?.businessTypeTourismTh ?? 'Tourism';
      case 'OTHER':
        return localizations?.businessTypeOtherTh ?? 'Other';
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: SunTheme.sunGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.brown.shade800,
                      ),
                      onPressed: () {
                        if (_currentPage > 0) {
                          // ถ้าอยู่ในขั้นตอนที่ 2 หรือ 3 ให้กลับไปขั้นตอนก่อนหน้า
                          _previousPage();
                        } else {
                          // ถ้าอยู่ในขั้นตอนแรก ให้กลับไปหน้า org code
                          Navigator.of(context).pushReplacementNamed('/org');
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        localizations.newMemberRegistration,
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.brown.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                        decoration: BoxDecoration(
                          color: index <= _currentPage
                              ? Colors.brown.shade700
                              : Colors.brown.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Form content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      _buildOrgInfoPage(),
                      _buildAdminInfoPage(),
                      _buildConfirmationPage(),
                    ],
                  ),
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _previousPage,
                          child: Text(
                            localizations.previousStep,
                            style: textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SunTheme.sunOrange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading
                            ? null
                            : (_currentPage < 2
                                  ? _nextPage
                                  : _submitRegistration),
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
                                _currentPage < 2
                                    ? localizations.nextStep
                                    : localizations.submitRequest,
                                style: textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrgInfoPage() {
    final localizations = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.organizationInfo,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.brown.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          _buildTextField(
            controller: _orgNameController,
            label: localizations.orgName,
            validator: (value) => value?.isEmpty == true
                ? localizations.pleaseEnterOrgName
                : null,
          ),
          const SizedBox(height: 16),

          // รหัสองค์กรพร้อมปุ่มสร้างใหม่ (ปุ่มอยู่ในช่อง input)
          _buildTextField(
            controller: _orgCodeController,
            label: localizations.orgCode,
            helperText: localizations.codeForLogin,
            readOnly: false, // อนุญาตให้แก้ไขได้
            onChanged: (value) {
              // Auto uppercase
              final cursorPosition = _orgCodeController.selection;
              _orgCodeController.value = _orgCodeController.value.copyWith(
                text: value.toUpperCase(),
                selection: cursorPosition,
              );
            },
            validator: (value) {
              if (value?.isEmpty == true) {
                return localizations.pleaseGenerateOrgCode;
              }
              if (value!.length < 3 || value.length > 30) {
                return localizations.pleaseGenerateOrgCode;
              }
              if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                return localizations.pleaseGenerateOrgCode;
              }
              return null;
            },
            // ปุ่ม reset อยู่ในช่อง input
            // ใช้ suffixIcon
            suffixIcon: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.brown),
              tooltip: localizations.generateNewCode,
              onPressed: _generateOrgCode,
            ),
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _orgEmailController,
            label: localizations.orgEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty == true) return localizations.pleaseEnterEmail;
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value!)) {
                return localizations.invalidEmailFormat;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _orgPhoneController,
            label: localizations.orgPhone,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value?.isEmpty == true) return localizations.pleaseEnterPhone;
              if (value != null &&
                  value.isNotEmpty &&
                  !RegExp(r'^\d+$').hasMatch(value)) {
                return localizations.phoneNumberOnlyError;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _companyRegistrationNumberController,
            label: localizations.companyRegistrationNumberLabel,
            keyboardType: TextInputType.number,
            helperText: localizations.companyRegistrationNumberHelperText,
            validator: (value) {
              if (value?.isEmpty == true) {
                return localizations.pleaseEnterCompanyRegistrationNumberTh;
              }
              if (value != null && !RegExp(r'^\d{13}$').hasMatch(value)) {
                return localizations.invalidCompanyRegistrationNumber;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _taxIdController,
            label: localizations.taxIdLabel,
            keyboardType: TextInputType.number,
            helperText: localizations.taxIdHelperText,
            validator: (value) {
              if (value?.isEmpty == true) {
                return localizations.pleaseEnterTaxIdTh;
              }
              if (value != null && !RegExp(r'^\d{13}$').hasMatch(value)) {
                return localizations.invalidTaxId;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // ประเภทธุรกิจ
          _buildDropdownField(
            label: localizations.businessTypeLabel,
            value: _selectedBusinessType.isEmpty ? null : _selectedBusinessType,
            items: [
              DropdownMenuItem(
                value: 'RETAIL',
                child: Text(localizations.businessTypeRetail),
              ),
              DropdownMenuItem(
                value: 'WHOLESALE',
                child: Text(localizations.businessTypeWholesale),
              ),
              DropdownMenuItem(
                value: 'MANUFACTURING',
                child: Text(localizations.businessTypeManufacturing),
              ),
              DropdownMenuItem(
                value: 'SERVICE',
                child: Text(localizations.businessTypeService),
              ),
              DropdownMenuItem(
                value: 'TECHNOLOGY',
                child: Text(localizations.businessTypeTechnology),
              ),
              DropdownMenuItem(
                value: 'EDUCATION',
                child: Text(localizations.businessTypeEducation),
              ),
              DropdownMenuItem(
                value: 'HEALTHCARE',
                child: Text(localizations.businessTypeHealthcare),
              ),
              DropdownMenuItem(
                value: 'FINANCE',
                child: Text(localizations.businessTypeFinance),
              ),
              DropdownMenuItem(
                value: 'CONSTRUCTION',
                child: Text(localizations.businessTypeConstruction),
              ),
              DropdownMenuItem(
                value: 'FOOD',
                child: Text(localizations.businessTypeFood),
              ),
              DropdownMenuItem(
                value: 'LOGISTICS',
                child: Text(localizations.businessTypeLogistics),
              ),
              DropdownMenuItem(
                value: 'TOURISM',
                child: Text(localizations.businessTypeTourism),
              ),
              DropdownMenuItem(
                value: 'OTHER',
                child: Text(localizations.businessTypeOther),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedBusinessType = value ?? '';
              });
            },
            validator: (value) =>
                value == null ? localizations.pleaseSelectBusinessType : null,
          ),
          const SizedBox(height: 16),

          // จำนวนพนักงาน
          _buildDropdownField(
            label: localizations.employeeCountLabel,
            value: _selectedEmployeeCount.isEmpty
                ? null
                : _selectedEmployeeCount,
            items: [
              DropdownMenuItem(
                value: '1-10',
                child: Text(localizations.employeeCount_1_10),
              ),
              DropdownMenuItem(
                value: '11-50',
                child: Text(localizations.employeeCount_11_50),
              ),
              DropdownMenuItem(
                value: '51-100',
                child: Text(localizations.employeeCount_51_100),
              ),
              DropdownMenuItem(
                value: '101-500',
                child: Text(localizations.employeeCount_101_500),
              ),
              DropdownMenuItem(
                value: '501-1000',
                child: Text(localizations.employeeCount_501_1000),
              ),
              DropdownMenuItem(
                value: '1000+',
                child: Text(localizations.employeeCount_1000plus),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedEmployeeCount = value ?? '';
              });
            },
            validator: (value) =>
                value == null ? localizations.pleaseSelectEmployeeCount : null,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _websiteController,
            label: localizations.websiteLabel,
            keyboardType: TextInputType.url,
            validator: (value) {
              // ไม่ต้องบังคับ http/https
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _orgAddressController,
            label: localizations.orgAddress,
            maxLines: 3,
            validator: (value) => value?.isEmpty == true
                ? localizations.pleaseEnterAddress
                : null,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _orgDescriptionController,
            label: localizations.orgDescription,
            maxLines: 3,
            validator: (value) => null, // ไม่บังคับ
          ),
          const SizedBox(height: 24),

          // ปุ่มสร้างข้อมูลทดสอบ (COMMENT OUT)
          /*
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.science_outlined,
                  color: Colors.orange.shade700,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  '💡 สำหรับการทดสอบ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'กดปุ่มด้านล่างเพื่อสร้างข้อมูลทดสอบที่ไม่ซ้ำกัน\nรหัสผ่าน Admin: temp123456\nเซิร์ฟเวอร์: \\${ApiService.baseUrl}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.orange.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _generateRandomData,
                        icon: const Icon(Icons.casino, color: Colors.white),
                        label: const Text(
                          '🎲 สร้างข้อมูล Random',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _clearForm,
                        icon: const Icon(Icons.clear_all, color: Colors.white),
                        label: const Text(
                          '🗑️ ล้างข้อมูล',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // ปุ่มทดสอบการเชื่อมต่อ
                ElevatedButton.icon(
                  onPressed: _testConnection,
                  icon: const Icon(Icons.wifi_find, color: Colors.white),
                  label: const Text(
                    '🔗 ทดสอบการเชื่อมต่อ',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          */
        ],
      ),
    );
  }

  Widget _buildAdminInfoPage() {
    final localizations = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.adminInfo,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.brown.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.adminDescription,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.brown.shade600),
          ),
          const SizedBox(height: 24),

          _buildTextField(
            controller: _adminNameController,
            label: localizations.adminName,
            validator: (value) => value?.isEmpty == true
                ? localizations.pleaseEnterAdminName
                : null,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _adminEmailController,
            label: localizations.adminEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty == true) return localizations.pleaseEnterEmail;
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value!)) {
                return localizations.invalidEmailFormat;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _adminPasswordController,
            label: '${localizations.password} *',
            obscureText: true,
            helperText: localizations.passwordRequirement,
            validator: (value) {
              if (value?.isEmpty == true) {
                return localizations.pleaseEnterPassword;
              }
              if (value!.length < 6) return localizations.passwordTooShort;
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _confirmPasswordController,
            label: localizations.confirmPassword,
            obscureText: true,
            validator: (value) {
              if (value?.isEmpty == true) {
                return localizations.pleaseConfirmPassword;
              }
              if (value != _adminPasswordController.text) {
                return localizations.passwordMismatch;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationPage() {
    final localizations = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.confirmationInfo,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.brown.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          _buildConfirmationCard(
            title: localizations.organizationInfo,
            items: [
              '${localizations.orgName.replaceAll(' *', '')}: ${_orgNameController.text}',
              '${localizations.orgCodeLabel}: ${_orgCodeController.text}',
              '${localizations.orgEmail.replaceAll(' *', '')}: ${_orgEmailController.text}',
              if (_orgPhoneController.text.isNotEmpty)
                '${localizations.orgPhone.replaceAll(' *', '')}: ${_orgPhoneController.text}',
              if (_companyRegistrationNumberController.text.isNotEmpty)
                '${localizations.companyRegistrationSummary}: ${_companyRegistrationNumberController.text}',
              if (_taxIdController.text.isNotEmpty)
                '${localizations.taxIdSummary}: ${_taxIdController.text}',
              '${localizations.businessTypeSummary}: ${_getBusinessTypeLabel(_selectedBusinessType)}',
              '${localizations.employeeCountSummary}: $_selectedEmployeeCount',
              if (_websiteController.text.isNotEmpty)
                '${localizations.websiteSummary}: ${_websiteController.text}',
              if (_orgAddressController.text.isNotEmpty)
                '${localizations.addressSummary}: ${_orgAddressController.text}',
              if (_orgDescriptionController.text.isNotEmpty)
                '${localizations.descriptionSummary}: ${_orgDescriptionController.text}',
            ],
          ),
          const SizedBox(height: 16),

          _buildConfirmationCard(
            title: localizations.adminInfo,
            items: [
              '${localizations.adminName.replaceAll(' *', '')}: ${_adminNameController.text}',
              '${localizations.adminEmail.replaceAll(' *', '')}: ${_adminEmailController.text}',
            ],
          ),
          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.brown.shade50.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.brown.shade300),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.brown.shade700,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.note,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.brown.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.waitingApprovalNote,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.brown.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? helperText,
    bool obscureText = false,
    bool readOnly = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Widget? suffixIcon, // เพิ่มพารามิเตอร์นี้
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(color: SunTheme.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.95),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelText: label,
        helperText: helperText,
        helperStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 12,
        ),
        labelStyle: const TextStyle(color: SunTheme.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        suffixIcon: suffixIcon, // เพิ่มตรงนี้
      ),
    );
  }

  Widget _buildConfirmationCard({
    required String title,
    required List<String> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: SunTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                item,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: SunTheme.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.95),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelText: label,
        labelStyle: const TextStyle(color: SunTheme.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      style: const TextStyle(color: SunTheme.textPrimary),
      dropdownColor: Colors.white,
    );
  }
}
