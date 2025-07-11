// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'package:frontend/core/l10n/app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SUN ERP';

  @override
  String get orgCodePrompt => 'Please enter your organization code';

  @override
  String get login => 'Login';

  @override
  String get registerOrg => 'Register Organization';

  @override
  String get employee => 'Employee';

  @override
  String get noEmployees => 'No employees found';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading...';

  @override
  String get home => 'Home';

  @override
  String get hrm => 'HRM';

  @override
  String get project => 'Project';

  @override
  String get purchasing => 'Purchasing';

  @override
  String get sales => 'Sales';

  @override
  String get inventory => 'Inventory';

  @override
  String get accounting => 'Accounting';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get orgCodeLabel => 'Organization Code';

  @override
  String get username => 'Username';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get forgotPasswordDialogContent =>
      'Please contact HR or the system administrator for password reset assistance.';

  @override
  String get employeeName => 'Employee Name';

  @override
  String get employeePosition => 'Position';

  @override
  String employeeId(Object id) {
    return 'Employee ID: $id';
  }

  @override
  String get checkIn => 'Check In';

  @override
  String get checkOut => 'Check Out';

  @override
  String get leave => 'Request Leave';

  @override
  String get leaveAdd => 'Add Leave';

  @override
  String get taskTitle => 'Your Tasks';

  @override
  String get taskItem => 'Task: Update customer info';

  @override
  String get projectTitle => 'Project';

  @override
  String get projectDetail => 'CRM System';

  @override
  String get hrAnnouncement => 'HR Announcement';

  @override
  String get hrAnnouncementTitle => 'Annual leave announcement';

  @override
  String get hrAnnouncementSubtitle => 'Company will be closed on 12-15 April';

  @override
  String get employeeModule => 'Employee';

  @override
  String get attendanceModule => 'Attendance';

  @override
  String get payrollModule => 'Payroll';

  @override
  String get leaveModule => 'Leave';

  @override
  String get leaveApprovalModule => 'Leave Approval';

  @override
  String get announcementModule => 'Announcement';

  @override
  String get employeeListTitle => 'Employee List';

  @override
  String get companyRegistrationNumber => 'Company Registration Number';

  @override
  String get companyRegistrationNumberHint =>
      '13-digit company registration number';

  @override
  String get pleaseEnterCompanyRegistrationNumber =>
      'Please enter company registration number';

  @override
  String get invalidCompanyRegistrationNumber =>
      'Company registration number must be 13 digits';

  @override
  String get taxId => 'Tax ID';

  @override
  String get taxIdHint => '13-digit tax identification number';

  @override
  String get pleaseEnterTaxId => 'Please enter tax ID';

  @override
  String get invalidTaxId => 'Tax ID must be 13 digits';

  @override
  String get invalidPhoneNumber => 'Phone number must contain only numbers';

  @override
  String get employeeListContent => 'Employee list content here';

  @override
  String get attendanceTitle => 'Time Attendance';

  @override
  String get attendanceContent => 'Attendance content here';

  @override
  String get payrollTitle => 'Payroll';

  @override
  String get payrollContent => 'Payroll content here';

  @override
  String get leaveTitle => 'Leave Management';

  @override
  String get leaveContent => 'Leave management content here';

  @override
  String get leaveApprovalTitle => 'Leave Approval';

  @override
  String get leaveApprovalContent => 'Leave approval content here';

  @override
  String get projectTaskModule => 'Project Task';

  @override
  String get projectTaskContent => 'Project task content here';

  @override
  String get projectStatusModule => 'Project Status';

  @override
  String get projectStatusContent => 'Project status content here';

  @override
  String get projectNotificationModule => 'Project Notification';

  @override
  String get projectNotificationContent => 'Project notification content here';

  @override
  String get salesCustomerModule => 'Customer';

  @override
  String get salesCustomerContent => 'Customer content here';

  @override
  String get salesQuotationModule => 'Quotation/Order';

  @override
  String get salesQuotationContent => 'Quotation/Order content here';

  @override
  String get salesReportModule => 'Sales Report';

  @override
  String get salesReportContent => 'Sales report content here';

  @override
  String get purchasingOrderModule => 'Purchase Order';

  @override
  String get purchasingOrderContent => 'Purchase order content here';

  @override
  String get purchasingSupplierModule => 'Supplier';

  @override
  String get purchasingSupplierContent => 'Supplier content here';

  @override
  String get purchasingReportModule => 'Purchasing Report';

  @override
  String get purchasingReportContent => 'Purchasing report content here';

  @override
  String get inventoryProductModule => 'Product/Material';

  @override
  String get inventoryProductContent => 'Product/material content here';

  @override
  String get inventoryStockModule => 'Stock';

  @override
  String get inventoryStockContent => 'Stock content here';

  @override
  String get inventoryTransactionModule => 'Transaction';

  @override
  String get inventoryTransactionContent => 'Transaction content here';

  @override
  String get accountingIncomeModule => 'Income/Expense';

  @override
  String get accountingIncomeContent => 'Income/expense content here';

  @override
  String get accountingFinanceModule => 'Finance';

  @override
  String get accountingFinanceContent => 'Finance content here';

  @override
  String get accountingReportModule => 'Accounting Report';

  @override
  String get accountingReportContent => 'Accounting report content here';

  @override
  String get crmCustomerModule => 'CRM Customer';

  @override
  String get crmCustomerContent => 'CRM customer content here';

  @override
  String get crmHistoryModule => 'Contact History';

  @override
  String get crmHistoryContent => 'Contact history content here';

  @override
  String get crmActivityModule => 'Sales Activity';

  @override
  String get crmActivityContent => 'Sales activity content here';

  @override
  String get reportsDashboardModule => 'Dashboard';

  @override
  String get reportsDashboardContent => 'Dashboard analytics content here';

  @override
  String get settingsUserModule => 'User Management';

  @override
  String get settingsUserContent => 'User management content here';

  @override
  String get settingsPermissionModule => 'Permission';

  @override
  String get settingsPermissionContent => 'Permission content here';

  @override
  String get settingsConfigModule => 'System Config';

  @override
  String get settingsConfigContent => 'System config content here';

  @override
  String get settingsNotificationModule => 'Notification Center';

  @override
  String get settingsNotificationContent => 'Notification center content here';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get addEmployee => 'Add Employee';

  @override
  String get editEmployee => 'Edit Employee';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete this employee?';

  @override
  String get changeImage => 'Change Image';

  @override
  String get pickStartDate => 'Pick Start Date';

  @override
  String get searchHint => 'Search name or employee ID';

  @override
  String get position => 'Position';

  @override
  String get name => 'Name';

  @override
  String get surname => 'Surname';

  @override
  String get employeeIdLabel => 'Employee ID';

  @override
  String get employeeCodeOrEmail => 'Employee Code / Email';

  @override
  String get employeeCodeOrEmailHint => 'Enter employee code or email address';

  @override
  String get pleaseEnterAllFields => 'Please enter all required fields';

  @override
  String get orgCodeNotFound =>
      'Organization code not found. Please select an organization first';

  @override
  String get level => 'Level';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get startDate => 'Start Date';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show Password';

  @override
  String get hidePassword => 'Hide Password';

  @override
  String get otStart => 'OT Start';

  @override
  String get otEnd => 'OT End';

  @override
  String get otRate => 'OT Rate';

  @override
  String get leaveTypeSick => 'Sick Leave';

  @override
  String get leaveTypePersonal => 'Personal Leave';

  @override
  String get leaveTypeVacation => 'Vacation Leave';

  @override
  String get leaveStatusPending => 'Pending';

  @override
  String get leaveStatusApproved => 'Approved';

  @override
  String get leaveStatusRejected => 'Rejected';

  @override
  String get addLeaveTitle => 'Add Leave';

  @override
  String get leaveDate => 'Leave Date';

  @override
  String get leaveReason => 'Reason';

  @override
  String get leaveSave => 'Save';

  @override
  String get leaveCancel => 'Cancel';

  @override
  String get pleaseSelectLeaveType => 'Please select leave type';

  @override
  String get pleaseSelectDate => 'Please select date';

  @override
  String get pleaseEnterReason => 'Please enter reason';

  @override
  String get leaveTypeLabel => 'Leave Type';

  @override
  String get saveError => 'Failed to save leave request. Please try again.';

  @override
  String get otSelectRate => 'Select OT Rate';

  @override
  String get otApprove => 'Approve';

  @override
  String get otReject => 'Reject';

  @override
  String get otRequest => 'OT request(s)';

  @override
  String get otMultiSelect => 'Multi-select';

  @override
  String get otCancelMultiSelect => 'Cancel multi-select';

  @override
  String get otSelectAll => 'Select all';

  @override
  String get otDeselectAll => 'Deselect all';

  @override
  String otSelectedCount(Object count) {
    return '$count selected';
  }

  @override
  String get otNoRequests => 'No OT requests found';

  @override
  String get otNoPendingRequests => 'No pending OT requests';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get retry => 'Retry';

  @override
  String get otStatusPending => 'Pending';

  @override
  String get otStatusApproved => 'Approved';

  @override
  String get otStatusRejected => 'Rejected';

  @override
  String otReason(Object reason) {
    return 'Reason: $reason';
  }

  @override
  String otApprovedWithRate(Object rate) {
    return 'Approved (rate x$rate)';
  }

  @override
  String get otApproveButton => 'Approve';

  @override
  String get otRejectButton => 'Reject';

  @override
  String get otSelectRateTitle => 'Select OT Rate';

  @override
  String otApproveOf(Object name) {
    return 'Approve OT of $name';
  }

  @override
  String get otCancel => 'Cancel';

  @override
  String get payrollEdit => 'Edit';

  @override
  String get payrollNoSearchResultTitle => 'No search results';

  @override
  String payrollNoSearchResultDescription(Object query) {
    return 'No employees found for \"$query\". Try another name or ID.';
  }

  @override
  String payrollLastUpdated(Object date) {
    return 'Last updated: $date';
  }

  @override
  String get otHourShort => 'hr.';

  @override
  String get payrollSearchHint => 'Search employee (name or ID)';

  @override
  String get payrollLoading => 'Loading payroll data...';

  @override
  String get payrollExporting => 'Exporting PDF...';

  @override
  String payrollExport(Object count) {
    return 'Export PDF ($count selected)';
  }

  @override
  String payrollExportConfirm(Object count) {
    return 'Export PDF for $count employees?';
  }

  @override
  String get payrollExported => 'Payslips exported successfully!';

  @override
  String get payrollNoData => 'No payroll data yet';

  @override
  String get payrollNoDataDescription =>
      'Start by adding payroll data for employees to manage and export payslips.';

  @override
  String get payrollAdd => 'Add Payroll';

  @override
  String get payrollNoAvailableEmployee => 'No available employees';

  @override
  String get payrollNoAvailableEmployeeToAdd => 'No available employee to add';

  @override
  String get payrollExportPayslipTitle => 'Export Payslip';

  @override
  String payrollAllSelected(Object count) {
    return 'Select employees to export payslips ($count found)';
  }

  @override
  String get payrollSelectAll => 'Select All';

  @override
  String get payrollClearSelection => 'Clear Selection';

  @override
  String payrollSelectedCount(Object selected, Object total) {
    return '$selected of $total selected';
  }

  @override
  String get payrollMultiSelectHint => 'You can select multiple employees';

  @override
  String get payrollError => 'Failed to load payroll data';

  @override
  String get payrollTryAgain => 'Try Again';

  @override
  String get payrollDeleteConfirm => 'Confirm Delete';

  @override
  String payrollDeleteConfirmMsg(Object name) {
    return 'Delete payroll data for \"$name\"?';
  }

  @override
  String get payrollDelete => 'Delete';

  @override
  String get payrollClose => 'Close';

  @override
  String get payrollTypeLabel => 'Type:';

  @override
  String get payrollTypeMonthly => 'Monthly';

  @override
  String get payrollTypeDaily => 'Daily';

  @override
  String payrollType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'monthly': 'Monthly',
      'daily': 'Daily',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String get payrollSalary => 'Salary:';

  @override
  String get payrollCreatedAt => 'Created at:';

  @override
  String get payrollLastUpdatedLabel => 'Last updated:';

  @override
  String payrollNoSearchResult(Object query) {
    return 'No employees found for \"$query\". Try another name or ID.';
  }

  @override
  String get payrollClearSearch => 'Clear Search';

  @override
  String get payrollNoEmployeeData =>
      'All employees already have payroll data or there are no employees in the system.';

  @override
  String get payrollSocialSecurity => 'Social Security';

  @override
  String get payrollSocialSecurityLabel => 'Social Security Amount';

  @override
  String get payrollSocialSecurityHint => 'Enter social security amount';

  @override
  String get payrollSalaryLabel => 'Salary Amount';

  @override
  String get payrollSalaryHintMonthly => 'e.g. 25000';

  @override
  String get payrollSalaryHintDaily => 'e.g. 500';

  @override
  String get payrollSalaryRequired => 'Please enter salary amount';

  @override
  String get payrollSalaryInvalid => 'Invalid salary amount';

  @override
  String get payrollBaht => 'Baht';

  @override
  String get payrollSocialSecurityInvalid => 'Invalid social security amount';

  @override
  String get connectionError => 'Connection error. Please try again.';

  @override
  String get success => 'Success';

  @override
  String get ok => 'OK';

  @override
  String get newMemberRegistration => 'New Organization Registration';

  @override
  String get previousStep => 'Previous Step';

  @override
  String get nextStep => 'Next Step';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get organizationInfo => 'Organization Information';

  @override
  String get orgName => 'Organization Name *';

  @override
  String get pleaseEnterOrgName => 'Please enter organization name';

  @override
  String get orgCode => 'Organization Code *';

  @override
  String get codeForLogin => 'Code for login access';

  @override
  String get pleaseGenerateOrgCode => 'Please generate organization code';

  @override
  String get generateNewCode => 'Generate New Code';

  @override
  String get orgEmail => 'Organization Email *';

  @override
  String get pleaseEnterEmail => 'Please enter email address';

  @override
  String get invalidEmailFormat => 'Invalid email format';

  @override
  String get orgPhone => 'Phone Number *';

  @override
  String get pleaseEnterPhone => 'Please enter phone number';

  @override
  String get orgAddress => 'Address *';

  @override
  String get pleaseEnterAddress => 'Please enter address';

  @override
  String get orgDescription => 'Description *';

  @override
  String get pleaseEnterDescription => 'Please enter description';

  @override
  String get adminInfo => 'Administrator Information';

  @override
  String get adminDescription =>
      'This person will be the system administrator for your organization';

  @override
  String get adminName => 'Administrator Name *';

  @override
  String get pleaseEnterAdminName => 'Please enter administrator name';

  @override
  String get adminEmail => 'Administrator Email *';

  @override
  String get passwordRequirement => 'Minimum 6 characters';

  @override
  String get pleaseEnterPassword => 'Please enter password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get confirmPassword => 'Confirm Password *';

  @override
  String get pleaseConfirmPassword => 'Please confirm password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get confirmationInfo => 'Confirmation Information';

  @override
  String get note => 'Note';

  @override
  String get waitingApprovalNote =>
      'Your registration request has been submitted and is awaiting approval from our admin team. You will receive a notification email once approved.';

  @override
  String get businessTypeLabel => 'Business Type *';

  @override
  String get businessTypeRetail => 'Retail';

  @override
  String get businessTypeWholesale => 'Wholesale';

  @override
  String get businessTypeManufacturing => 'Manufacturing';

  @override
  String get businessTypeService => 'Service';

  @override
  String get businessTypeTechnology => 'Technology';

  @override
  String get businessTypeEducation => 'Education';

  @override
  String get businessTypeHealthcare => 'Healthcare';

  @override
  String get businessTypeFinance => 'Finance';

  @override
  String get businessTypeConstruction => 'Construction';

  @override
  String get businessTypeFood => 'Food & Beverage';

  @override
  String get businessTypeLogistics => 'Logistics';

  @override
  String get businessTypeTourism => 'Tourism';

  @override
  String get businessTypeOther => 'Other';

  @override
  String get pleaseSelectBusinessType => 'Please select business type';

  @override
  String get employeeCountLabel => 'Employee Count *';

  @override
  String get employeeCount_1_10 => '1-10 employees';

  @override
  String get employeeCount_11_50 => '11-50 employees';

  @override
  String get employeeCount_51_100 => '51-100 employees';

  @override
  String get employeeCount_101_500 => '101-500 employees';

  @override
  String get employeeCount_501_1000 => '501-1000 employees';

  @override
  String get employeeCount_1000plus => 'More than 1000 employees';

  @override
  String get pleaseSelectEmployeeCount => 'Please select employee count';

  @override
  String get websiteLabel => 'Website';

  @override
  String get websiteInvalidFormat =>
      'Website must start with http:// or https://';

  @override
  String get pleaseEnterOrgCode => 'Please enter organization code';

  @override
  String get invalidOrgCode => 'Invalid organization code';

  @override
  String get orgNotFound => 'Organization code not found';

  @override
  String get orgNotApproved =>
      'Organization is not approved or cannot login yet';

  @override
  String get orgCheckError => 'Error checking organization';

  @override
  String get serverConnectionError => 'Error connecting to server';

  @override
  String get back => 'Back';

  @override
  String get languageSelection => 'Select Language';

  @override
  String get registrationError => 'Registration error occurred';

  @override
  String get serverConnectionErrorDetail => 'Server connection error';

  @override
  String get businessTypeSummary => 'Business Type';

  @override
  String get employeeCountSummary => 'Employee Count';

  @override
  String get websiteSummary => 'Website';

  @override
  String get descriptionSummary => 'Description';

  @override
  String get noWebsite => 'None';

  @override
  String get noDescription => 'None';

  @override
  String get businessTypeRetailTh => 'Retail';

  @override
  String get businessTypeWholesaleTh => 'Wholesale';

  @override
  String get businessTypeManufacturingTh => 'Manufacturing';

  @override
  String get businessTypeServiceTh => 'Service';

  @override
  String get businessTypeTechnologyTh => 'Technology';

  @override
  String get businessTypeEducationTh => 'Education';

  @override
  String get businessTypeHealthcareTh => 'Healthcare';

  @override
  String get businessTypeFinanceTh => 'Finance';

  @override
  String get businessTypeConstructionTh => 'Construction';

  @override
  String get businessTypeFoodTh => 'Food & Beverage';

  @override
  String get businessTypeLogisticsTh => 'Logistics';

  @override
  String get businessTypeTourismTh => 'Tourism';

  @override
  String get businessTypeOtherTh => 'Other';

  @override
  String get phoneNumberOnlyError => 'Phone number must contain only numbers';

  @override
  String get companyRegistrationNumberLabel => 'Company Registration Number *';

  @override
  String get companyRegistrationNumberHelperText =>
      '13-digit company registration number';

  @override
  String get pleaseEnterCompanyRegistrationNumberTh =>
      'Please enter company registration number';

  @override
  String get taxIdLabel => 'Tax ID *';

  @override
  String get taxIdHelperText => '13-digit tax identification number';

  @override
  String get pleaseEnterTaxIdTh => 'Please enter tax ID';

  @override
  String get companyRegistrationSummary => 'Company Registration Number';

  @override
  String get taxIdSummary => 'Tax ID';

  @override
  String get addressSummary => 'Address';

  @override
  String get errorRequiredFields => 'Please fill in all required fields.';

  @override
  String get errorOrgNotFound => 'Organization code not found.';

  @override
  String get errorOrgNotApproved => 'Organization is not approved yet.';

  @override
  String get errorOrgSuspended => 'Organization is suspended.';

  @override
  String get errorOrgExpired => 'Organization subscription has expired.';

  @override
  String get errorUserSuspended => 'User account is suspended.';

  @override
  String get errorInvalidCredentials =>
      'Invalid email/employee ID or password.';

  @override
  String get errorLoginError => 'An error occurred during login.';
}
