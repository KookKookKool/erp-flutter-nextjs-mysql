import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SUN ERP'**
  String get appTitle;

  /// No description provided for @orgCodePrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter your organization code'**
  String get orgCodePrompt;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @registerOrg.
  ///
  /// In en, this message translates to:
  /// **'Register Organization'**
  String get registerOrg;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @noEmployees.
  ///
  /// In en, this message translates to:
  /// **'No employees found'**
  String get noEmployees;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @hrm.
  ///
  /// In en, this message translates to:
  /// **'HRM'**
  String get hrm;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @purchasing.
  ///
  /// In en, this message translates to:
  /// **'Purchasing'**
  String get purchasing;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @accounting.
  ///
  /// In en, this message translates to:
  /// **'Accounting'**
  String get accounting;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @orgCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Organization Code'**
  String get orgCodeLabel;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Please contact HR or the system administrator for password reset assistance.'**
  String get forgotPasswordDialogContent;

  /// No description provided for @employeeName.
  ///
  /// In en, this message translates to:
  /// **'Employee Name'**
  String get employeeName;

  /// No description provided for @employeePosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get employeePosition;

  /// Employee ID label
  ///
  /// In en, this message translates to:
  /// **'Employee ID: {id}'**
  String employeeId(Object id);

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Request Leave'**
  String get leave;

  /// No description provided for @leaveAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Leave'**
  String get leaveAdd;

  /// No description provided for @taskTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Tasks'**
  String get taskTitle;

  /// No description provided for @taskItem.
  ///
  /// In en, this message translates to:
  /// **'Task: Update customer info'**
  String get taskItem;

  /// No description provided for @projectTitle.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get projectTitle;

  /// No description provided for @projectDetail.
  ///
  /// In en, this message translates to:
  /// **'CRM System'**
  String get projectDetail;

  /// No description provided for @hrAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'HR Announcement'**
  String get hrAnnouncement;

  /// No description provided for @hrAnnouncementTitle.
  ///
  /// In en, this message translates to:
  /// **'Annual leave announcement'**
  String get hrAnnouncementTitle;

  /// No description provided for @hrAnnouncementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Company will be closed on 12-15 April'**
  String get hrAnnouncementSubtitle;

  /// No description provided for @employeeModule.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employeeModule;

  /// No description provided for @attendanceModule.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendanceModule;

  /// No description provided for @payrollModule.
  ///
  /// In en, this message translates to:
  /// **'Payroll'**
  String get payrollModule;

  /// No description provided for @leaveModule.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leaveModule;

  /// No description provided for @leaveApprovalModule.
  ///
  /// In en, this message translates to:
  /// **'Leave Approval'**
  String get leaveApprovalModule;

  /// No description provided for @announcementModule.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get announcementModule;

  /// No description provided for @employeeListTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee List'**
  String get employeeListTitle;

  /// No description provided for @companyRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Company Registration Number'**
  String get companyRegistrationNumber;

  /// No description provided for @companyRegistrationNumberHint.
  ///
  /// In en, this message translates to:
  /// **'13-digit company registration number'**
  String get companyRegistrationNumberHint;

  /// No description provided for @pleaseEnterCompanyRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter company registration number'**
  String get pleaseEnterCompanyRegistrationNumber;

  /// No description provided for @invalidCompanyRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Company registration number must be 13 digits'**
  String get invalidCompanyRegistrationNumber;

  /// No description provided for @taxId.
  ///
  /// In en, this message translates to:
  /// **'Tax ID'**
  String get taxId;

  /// No description provided for @taxIdHint.
  ///
  /// In en, this message translates to:
  /// **'13-digit tax identification number'**
  String get taxIdHint;

  /// No description provided for @pleaseEnterTaxId.
  ///
  /// In en, this message translates to:
  /// **'Please enter tax ID'**
  String get pleaseEnterTaxId;

  /// No description provided for @invalidTaxId.
  ///
  /// In en, this message translates to:
  /// **'Tax ID must be 13 digits'**
  String get invalidTaxId;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number must contain only numbers'**
  String get invalidPhoneNumber;

  /// No description provided for @employeeListContent.
  ///
  /// In en, this message translates to:
  /// **'Employee list content here'**
  String get employeeListContent;

  /// No description provided for @attendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Attendance'**
  String get attendanceTitle;

  /// No description provided for @attendanceContent.
  ///
  /// In en, this message translates to:
  /// **'Attendance content here'**
  String get attendanceContent;

  /// No description provided for @payrollTitle.
  ///
  /// In en, this message translates to:
  /// **'Payroll'**
  String get payrollTitle;

  /// No description provided for @payrollContent.
  ///
  /// In en, this message translates to:
  /// **'Payroll content here'**
  String get payrollContent;

  /// No description provided for @leaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Management'**
  String get leaveTitle;

  /// No description provided for @leaveContent.
  ///
  /// In en, this message translates to:
  /// **'Leave management content here'**
  String get leaveContent;

  /// No description provided for @leaveApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Approval'**
  String get leaveApprovalTitle;

  /// No description provided for @leaveApprovalContent.
  ///
  /// In en, this message translates to:
  /// **'Leave approval content here'**
  String get leaveApprovalContent;

  /// No description provided for @projectTaskModule.
  ///
  /// In en, this message translates to:
  /// **'Project Task'**
  String get projectTaskModule;

  /// No description provided for @projectTaskContent.
  ///
  /// In en, this message translates to:
  /// **'Project task content here'**
  String get projectTaskContent;

  /// No description provided for @projectStatusModule.
  ///
  /// In en, this message translates to:
  /// **'Project Status'**
  String get projectStatusModule;

  /// No description provided for @projectStatusContent.
  ///
  /// In en, this message translates to:
  /// **'Project status content here'**
  String get projectStatusContent;

  /// No description provided for @projectNotificationModule.
  ///
  /// In en, this message translates to:
  /// **'Project Notification'**
  String get projectNotificationModule;

  /// No description provided for @projectNotificationContent.
  ///
  /// In en, this message translates to:
  /// **'Project notification content here'**
  String get projectNotificationContent;

  /// No description provided for @salesCustomerModule.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get salesCustomerModule;

  /// No description provided for @salesCustomerContent.
  ///
  /// In en, this message translates to:
  /// **'Customer content here'**
  String get salesCustomerContent;

  /// No description provided for @salesQuotationModule.
  ///
  /// In en, this message translates to:
  /// **'Quotation/Order'**
  String get salesQuotationModule;

  /// No description provided for @salesQuotationContent.
  ///
  /// In en, this message translates to:
  /// **'Quotation/Order content here'**
  String get salesQuotationContent;

  /// No description provided for @salesReportModule.
  ///
  /// In en, this message translates to:
  /// **'Sales Report'**
  String get salesReportModule;

  /// No description provided for @salesReportContent.
  ///
  /// In en, this message translates to:
  /// **'Sales report content here'**
  String get salesReportContent;

  /// No description provided for @purchasingOrderModule.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order'**
  String get purchasingOrderModule;

  /// No description provided for @purchasingOrderContent.
  ///
  /// In en, this message translates to:
  /// **'Purchase order content here'**
  String get purchasingOrderContent;

  /// No description provided for @purchasingSupplierModule.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get purchasingSupplierModule;

  /// No description provided for @purchasingSupplierContent.
  ///
  /// In en, this message translates to:
  /// **'Supplier content here'**
  String get purchasingSupplierContent;

  /// No description provided for @purchasingReportModule.
  ///
  /// In en, this message translates to:
  /// **'Purchasing Report'**
  String get purchasingReportModule;

  /// No description provided for @purchasingReportContent.
  ///
  /// In en, this message translates to:
  /// **'Purchasing report content here'**
  String get purchasingReportContent;

  /// No description provided for @inventoryProductModule.
  ///
  /// In en, this message translates to:
  /// **'Product/Material'**
  String get inventoryProductModule;

  /// No description provided for @inventoryProductContent.
  ///
  /// In en, this message translates to:
  /// **'Product/material content here'**
  String get inventoryProductContent;

  /// No description provided for @inventoryStockModule.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get inventoryStockModule;

  /// No description provided for @inventoryStockContent.
  ///
  /// In en, this message translates to:
  /// **'Stock content here'**
  String get inventoryStockContent;

  /// No description provided for @inventoryTransactionModule.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get inventoryTransactionModule;

  /// No description provided for @inventoryTransactionContent.
  ///
  /// In en, this message translates to:
  /// **'Transaction content here'**
  String get inventoryTransactionContent;

  /// No description provided for @accountingIncomeModule.
  ///
  /// In en, this message translates to:
  /// **'Income/Expense'**
  String get accountingIncomeModule;

  /// No description provided for @accountingIncomeContent.
  ///
  /// In en, this message translates to:
  /// **'Income/expense content here'**
  String get accountingIncomeContent;

  /// No description provided for @accountingFinanceModule.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get accountingFinanceModule;

  /// No description provided for @accountingFinanceContent.
  ///
  /// In en, this message translates to:
  /// **'Finance content here'**
  String get accountingFinanceContent;

  /// No description provided for @accountingReportModule.
  ///
  /// In en, this message translates to:
  /// **'Accounting Report'**
  String get accountingReportModule;

  /// No description provided for @accountingReportContent.
  ///
  /// In en, this message translates to:
  /// **'Accounting report content here'**
  String get accountingReportContent;

  /// No description provided for @crmCustomerModule.
  ///
  /// In en, this message translates to:
  /// **'CRM Customer'**
  String get crmCustomerModule;

  /// No description provided for @crmCustomerContent.
  ///
  /// In en, this message translates to:
  /// **'CRM customer content here'**
  String get crmCustomerContent;

  /// No description provided for @crmHistoryModule.
  ///
  /// In en, this message translates to:
  /// **'Contact History'**
  String get crmHistoryModule;

  /// No description provided for @crmHistoryContent.
  ///
  /// In en, this message translates to:
  /// **'Contact history content here'**
  String get crmHistoryContent;

  /// No description provided for @crmActivityModule.
  ///
  /// In en, this message translates to:
  /// **'Sales Activity'**
  String get crmActivityModule;

  /// No description provided for @crmActivityContent.
  ///
  /// In en, this message translates to:
  /// **'Sales activity content here'**
  String get crmActivityContent;

  /// No description provided for @reportsDashboardModule.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get reportsDashboardModule;

  /// No description provided for @reportsDashboardContent.
  ///
  /// In en, this message translates to:
  /// **'Dashboard analytics content here'**
  String get reportsDashboardContent;

  /// No description provided for @settingsUserModule.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get settingsUserModule;

  /// No description provided for @settingsUserContent.
  ///
  /// In en, this message translates to:
  /// **'User management content here'**
  String get settingsUserContent;

  /// No description provided for @settingsPermissionModule.
  ///
  /// In en, this message translates to:
  /// **'Permission'**
  String get settingsPermissionModule;

  /// No description provided for @settingsPermissionContent.
  ///
  /// In en, this message translates to:
  /// **'Permission content here'**
  String get settingsPermissionContent;

  /// No description provided for @settingsConfigModule.
  ///
  /// In en, this message translates to:
  /// **'System Config'**
  String get settingsConfigModule;

  /// No description provided for @settingsConfigContent.
  ///
  /// In en, this message translates to:
  /// **'System config content here'**
  String get settingsConfigContent;

  /// No description provided for @settingsNotificationModule.
  ///
  /// In en, this message translates to:
  /// **'Notification Center'**
  String get settingsNotificationModule;

  /// No description provided for @settingsNotificationContent.
  ///
  /// In en, this message translates to:
  /// **'Notification center content here'**
  String get settingsNotificationContent;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @addEmployee.
  ///
  /// In en, this message translates to:
  /// **'Add Employee'**
  String get addEmployee;

  /// No description provided for @editEmployee.
  ///
  /// In en, this message translates to:
  /// **'Edit Employee'**
  String get editEmployee;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this employee?'**
  String get confirmDeleteMessage;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get changeImage;

  /// No description provided for @pickStartDate.
  ///
  /// In en, this message translates to:
  /// **'Pick Start Date'**
  String get pickStartDate;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name or employee ID'**
  String get searchHint;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @employeeIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get employeeIdLabel;

  /// No description provided for @employeeCodeOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Employee Code / Email'**
  String get employeeCodeOrEmail;

  /// No description provided for @employeeCodeOrEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter employee code or email address'**
  String get employeeCodeOrEmailHint;

  /// No description provided for @pleaseEnterAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please enter all required fields'**
  String get pleaseEnterAllFields;

  /// No description provided for @orgCodeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Organization code not found. Please select an organization first'**
  String get orgCodeNotFound;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show Password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide Password'**
  String get hidePassword;

  /// No description provided for @otStart.
  ///
  /// In en, this message translates to:
  /// **'OT Start'**
  String get otStart;

  /// No description provided for @otEnd.
  ///
  /// In en, this message translates to:
  /// **'OT End'**
  String get otEnd;

  /// No description provided for @otRate.
  ///
  /// In en, this message translates to:
  /// **'OT Rate'**
  String get otRate;

  /// No description provided for @leaveTypeSick.
  ///
  /// In en, this message translates to:
  /// **'Sick Leave'**
  String get leaveTypeSick;

  /// No description provided for @leaveTypePersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal Leave'**
  String get leaveTypePersonal;

  /// No description provided for @leaveTypeVacation.
  ///
  /// In en, this message translates to:
  /// **'Vacation Leave'**
  String get leaveTypeVacation;

  /// No description provided for @leaveStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get leaveStatusPending;

  /// No description provided for @leaveStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get leaveStatusApproved;

  /// No description provided for @leaveStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get leaveStatusRejected;

  /// No description provided for @addLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Leave'**
  String get addLeaveTitle;

  /// No description provided for @leaveDate.
  ///
  /// In en, this message translates to:
  /// **'Leave Date'**
  String get leaveDate;

  /// No description provided for @leaveReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get leaveReason;

  /// No description provided for @leaveSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get leaveSave;

  /// No description provided for @leaveCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get leaveCancel;

  /// No description provided for @pleaseSelectLeaveType.
  ///
  /// In en, this message translates to:
  /// **'Please select leave type'**
  String get pleaseSelectLeaveType;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select date'**
  String get pleaseSelectDate;

  /// No description provided for @pleaseEnterReason.
  ///
  /// In en, this message translates to:
  /// **'Please enter reason'**
  String get pleaseEnterReason;

  /// No description provided for @leaveTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Leave Type'**
  String get leaveTypeLabel;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save leave request. Please try again.'**
  String get saveError;

  /// No description provided for @otSelectRate.
  ///
  /// In en, this message translates to:
  /// **'Select OT Rate'**
  String get otSelectRate;

  /// No description provided for @otApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get otApprove;

  /// No description provided for @otReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get otReject;

  /// No description provided for @otRequest.
  ///
  /// In en, this message translates to:
  /// **'OT request(s)'**
  String get otRequest;

  /// No description provided for @otMultiSelect.
  ///
  /// In en, this message translates to:
  /// **'Multi-select'**
  String get MultiSelect;

  /// No description provided for @otCancelMultiSelect.
  ///
  /// In en, this message translates to:
  /// **'Cancel multi-select'**
  String get CancelMultiSelect;

  /// No description provided for @otSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get SelectAll;

  /// No description provided for @otDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get DeselectAll;

  /// Number of selected OT requests
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String SelectedCount(Object count);

  /// No description provided for @otNoRequests.
  ///
  /// In en, this message translates to:
  /// **'No OT requests found'**
  String get otNoRequests;

  /// No description provided for @otNoPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending OT requests'**
  String get otNoPendingRequests;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @otStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get otStatusPending;

  /// No description provided for @otStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get otStatusApproved;

  /// No description provided for @otStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get otStatusRejected;

  /// OT reason label
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String otReason(Object reason);

  /// OT approved with rate label
  ///
  /// In en, this message translates to:
  /// **'Approved (rate x{rate})'**
  String otApprovedWithRate(Object rate);

  /// No description provided for @otApproveButton.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get otApproveButton;

  /// No description provided for @otRejectButton.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get otRejectButton;

  /// No description provided for @otSelectRateTitle.
  ///
  /// In en, this message translates to:
  /// **'Select OT Rate'**
  String get otSelectRateTitle;

  /// Approve OT of employee
  ///
  /// In en, this message translates to:
  /// **'Approve OT of {name}'**
  String otApproveOf(Object name);

  /// No description provided for @otCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get otCancel;

  /// No description provided for @payrollEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get payrollEdit;

  /// No description provided for @payrollNoSearchResultTitle.
  ///
  /// In en, this message translates to:
  /// **'No search results'**
  String get payrollNoSearchResultTitle;

  /// No search result for payroll
  ///
  /// In en, this message translates to:
  /// **'No employees found for \"{query}\". Try another name or ID.'**
  String payrollNoSearchResultDescription(Object query);

  /// Payroll last updated label
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String payrollLastUpdated(Object date);

  /// No description provided for @otHourShort.
  ///
  /// In en, this message translates to:
  /// **'hr.'**
  String get otHourShort;

  /// No description provided for @payrollSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search employee (name or ID)'**
  String get payrollSearchHint;

  /// No description provided for @payrollLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading payroll data...'**
  String get payrollLoading;

  /// No description provided for @payrollExporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting PDF...'**
  String get payrollExporting;

  /// Export PDF button label
  ///
  /// In en, this message translates to:
  /// **'Export PDF ({count} selected)'**
  String payrollExport(Object count);

  /// Export PDF confirm dialog
  ///
  /// In en, this message translates to:
  /// **'Export PDF for {count} employees?'**
  String payrollExportConfirm(Object count);

  /// No description provided for @payrollExported.
  ///
  /// In en, this message translates to:
  /// **'Payslips exported successfully!'**
  String get payrollExported;

  /// No description provided for @payrollNoData.
  ///
  /// In en, this message translates to:
  /// **'No payroll data yet'**
  String get payrollNoData;

  /// No description provided for @payrollNoDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Start by adding payroll data for employees to manage and export payslips.'**
  String get payrollNoDataDescription;

  /// No description provided for @payrollAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Payroll'**
  String get payrollAdd;

  /// No description provided for @payrollNoAvailableEmployee.
  ///
  /// In en, this message translates to:
  /// **'No available employees'**
  String get payrollNoAvailableEmployee;

  /// No description provided for @payrollNoAvailableEmployeeToAdd.
  ///
  /// In en, this message translates to:
  /// **'No available employee to add'**
  String get payrollNoAvailableEmployeeToAdd;

  /// No description provided for @payrollExportPayslipTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Payslip'**
  String get payrollExportPayslipTitle;

  /// Select employees info
  ///
  /// In en, this message translates to:
  /// **'Select employees to export payslips ({count} found)'**
  String payrollAllSelected(Object count);

  /// No description provided for @payrollSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get payrollSelectAll;

  /// No description provided for @payrollClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear Selection'**
  String get payrollClearSelection;

  /// Selected count info
  ///
  /// In en, this message translates to:
  /// **'{selected} of {total} selected'**
  String payrollSelectedCount(Object selected, Object total);

  /// No description provided for @payrollMultiSelectHint.
  ///
  /// In en, this message translates to:
  /// **'You can select multiple employees'**
  String get payrollMultiSelectHint;

  /// No description provided for @payrollError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load payroll data'**
  String get payrollError;

  /// No description provided for @payrollTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get payrollTryAgain;

  /// No description provided for @payrollDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get payrollDeleteConfirm;

  /// Delete confirm message
  ///
  /// In en, this message translates to:
  /// **'Delete payroll data for \"{name}\"?'**
  String payrollDeleteConfirmMsg(Object name);

  /// No description provided for @payrollDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get payrollDelete;

  /// No description provided for @payrollClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get payrollClose;

  /// No description provided for @payrollTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type:'**
  String get payrollTypeLabel;

  /// No description provided for @payrollTypeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get payrollTypeMonthly;

  /// No description provided for @payrollTypeDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get payrollTypeDaily;

  /// Payroll type label
  ///
  /// In en, this message translates to:
  /// **'{type, select, monthly {Monthly} daily {Daily} other {Unknown}}'**
  String payrollType(String type);

  /// No description provided for @payrollSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary:'**
  String get payrollSalary;

  /// No description provided for @payrollCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created at:'**
  String get payrollCreatedAt;

  /// No description provided for @payrollLastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last updated:'**
  String get payrollLastUpdatedLabel;

  /// No search result for payroll
  ///
  /// In en, this message translates to:
  /// **'No employees found for \"{query}\". Try another name or ID.'**
  String payrollNoSearchResult(Object query);

  /// No description provided for @payrollClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get payrollClearSearch;

  /// No description provided for @payrollNoEmployeeData.
  ///
  /// In en, this message translates to:
  /// **'All employees already have payroll data or there are no employees in the system.'**
  String get payrollNoEmployeeData;

  /// No description provided for @payrollSocialSecurity.
  ///
  /// In en, this message translates to:
  /// **'Social Security'**
  String get payrollSocialSecurity;

  /// No description provided for @payrollSocialSecurityLabel.
  ///
  /// In en, this message translates to:
  /// **'Social Security Amount'**
  String get payrollSocialSecurityLabel;

  /// No description provided for @payrollSocialSecurityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter social security amount'**
  String get payrollSocialSecurityHint;

  /// No description provided for @payrollSalaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Salary Amount'**
  String get payrollSalaryLabel;

  /// No description provided for @payrollSalaryHintMonthly.
  ///
  /// In en, this message translates to:
  /// **'e.g. 25000'**
  String get payrollSalaryHintMonthly;

  /// No description provided for @payrollSalaryHintDaily.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500'**
  String get payrollSalaryHintDaily;

  /// No description provided for @payrollSalaryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter salary amount'**
  String get payrollSalaryRequired;

  /// No description provided for @payrollSalaryInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid salary amount'**
  String get payrollSalaryInvalid;

  /// No description provided for @payrollBaht.
  ///
  /// In en, this message translates to:
  /// **'Baht'**
  String get payrollBaht;

  /// No description provided for @payrollSocialSecurityInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid social security amount'**
  String get payrollSocialSecurityInvalid;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please try again.'**
  String get connectionError;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @newMemberRegistration.
  ///
  /// In en, this message translates to:
  /// **'New Organization Registration'**
  String get newMemberRegistration;

  /// No description provided for @previousStep.
  ///
  /// In en, this message translates to:
  /// **'Previous Step'**
  String get previousStep;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @organizationInfo.
  ///
  /// In en, this message translates to:
  /// **'Organization Information'**
  String get organizationInfo;

  /// No description provided for @orgName.
  ///
  /// In en, this message translates to:
  /// **'Organization Name *'**
  String get orgName;

  /// No description provided for @pleaseEnterOrgName.
  ///
  /// In en, this message translates to:
  /// **'Please enter organization name'**
  String get pleaseEnterOrgName;

  /// No description provided for @orgCode.
  ///
  /// In en, this message translates to:
  /// **'Organization Code *'**
  String get orgCode;

  /// No description provided for @codeForLogin.
  ///
  /// In en, this message translates to:
  /// **'Code for login access'**
  String get codeForLogin;

  /// No description provided for @pleaseGenerateOrgCode.
  ///
  /// In en, this message translates to:
  /// **'Please generate organization code'**
  String get pleaseGenerateOrgCode;

  /// No description provided for @generateNewCode.
  ///
  /// In en, this message translates to:
  /// **'Generate New Code'**
  String get generateNewCode;

  /// No description provided for @orgEmail.
  ///
  /// In en, this message translates to:
  /// **'Organization Email *'**
  String get orgEmail;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email address'**
  String get pleaseEnterEmail;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// No description provided for @orgPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
  String get orgPhone;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @orgAddress.
  ///
  /// In en, this message translates to:
  /// **'Address *'**
  String get orgAddress;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter address'**
  String get pleaseEnterAddress;

  /// No description provided for @orgDescription.
  ///
  /// In en, this message translates to:
  /// **'Description *'**
  String get orgDescription;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter description'**
  String get pleaseEnterDescription;

  /// No description provided for @adminInfo.
  ///
  /// In en, this message translates to:
  /// **'Administrator Information'**
  String get adminInfo;

  /// No description provided for @adminDescription.
  ///
  /// In en, this message translates to:
  /// **'This person will be the system administrator for your organization'**
  String get adminDescription;

  /// No description provided for @adminName.
  ///
  /// In en, this message translates to:
  /// **'Administrator Name *'**
  String get adminName;

  /// No description provided for @pleaseEnterAdminName.
  ///
  /// In en, this message translates to:
  /// **'Please enter administrator name'**
  String get pleaseEnterAdminName;

  /// No description provided for @adminEmail.
  ///
  /// In en, this message translates to:
  /// **'Administrator Email *'**
  String get adminEmail;

  /// No description provided for @passwordRequirement.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get passwordRequirement;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password *'**
  String get confirmPassword;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @confirmationInfo.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Information'**
  String get confirmationInfo;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @waitingApprovalNote.
  ///
  /// In en, this message translates to:
  /// **'Your registration request has been submitted and is awaiting approval from our admin team. You will receive a notification email once approved.'**
  String get waitingApprovalNote;

  /// No description provided for @businessTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Type *'**
  String get businessTypeLabel;

  /// No description provided for @businessTypeRetail.
  ///
  /// In en, this message translates to:
  /// **'Retail'**
  String get businessTypeRetail;

  /// No description provided for @businessTypeWholesale.
  ///
  /// In en, this message translates to:
  /// **'Wholesale'**
  String get businessTypeWholesale;

  /// No description provided for @businessTypeManufacturing.
  ///
  /// In en, this message translates to:
  /// **'Manufacturing'**
  String get businessTypeManufacturing;

  /// No description provided for @businessTypeService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get businessTypeService;

  /// No description provided for @businessTypeTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get businessTypeTechnology;

  /// No description provided for @businessTypeEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get businessTypeEducation;

  /// No description provided for @businessTypeHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get businessTypeHealthcare;

  /// No description provided for @businessTypeFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get businessTypeFinance;

  /// No description provided for @businessTypeConstruction.
  ///
  /// In en, this message translates to:
  /// **'Construction'**
  String get businessTypeConstruction;

  /// No description provided for @businessTypeFood.
  ///
  /// In en, this message translates to:
  /// **'Food & Beverage'**
  String get businessTypeFood;

  /// No description provided for @businessTypeLogistics.
  ///
  /// In en, this message translates to:
  /// **'Logistics'**
  String get businessTypeLogistics;

  /// No description provided for @businessTypeTourism.
  ///
  /// In en, this message translates to:
  /// **'Tourism'**
  String get businessTypeTourism;

  /// No description provided for @businessTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get businessTypeOther;

  /// No description provided for @pleaseSelectBusinessType.
  ///
  /// In en, this message translates to:
  /// **'Please select business type'**
  String get pleaseSelectBusinessType;

  /// No description provided for @employeeCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Employee Count *'**
  String get employeeCountLabel;

  /// No description provided for @employeeCount_1_10.
  ///
  /// In en, this message translates to:
  /// **'1-10 employees'**
  String get employeeCount_1_10;

  /// No description provided for @employeeCount_11_50.
  ///
  /// In en, this message translates to:
  /// **'11-50 employees'**
  String get employeeCount_11_50;

  /// No description provided for @employeeCount_51_100.
  ///
  /// In en, this message translates to:
  /// **'51-100 employees'**
  String get employeeCount_51_100;

  /// No description provided for @employeeCount_101_500.
  ///
  /// In en, this message translates to:
  /// **'101-500 employees'**
  String get employeeCount_101_500;

  /// No description provided for @employeeCount_501_1000.
  ///
  /// In en, this message translates to:
  /// **'501-1000 employees'**
  String get employeeCount_501_1000;

  /// No description provided for @employeeCount_1000plus.
  ///
  /// In en, this message translates to:
  /// **'More than 1000 employees'**
  String get employeeCount_1000plus;

  /// No description provided for @pleaseSelectEmployeeCount.
  ///
  /// In en, this message translates to:
  /// **'Please select employee count'**
  String get pleaseSelectEmployeeCount;

  /// No description provided for @websiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get websiteLabel;

  /// No description provided for @websiteInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Website must start with http:// or https://'**
  String get websiteInvalidFormat;

  /// No description provided for @pleaseEnterOrgCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter organization code'**
  String get pleaseEnterOrgCode;

  /// No description provided for @invalidOrgCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid organization code'**
  String get invalidOrgCode;

  /// No description provided for @orgNotFound.
  ///
  /// In en, this message translates to:
  /// **'Organization code not found'**
  String get orgNotFound;

  /// No description provided for @orgNotApproved.
  ///
  /// In en, this message translates to:
  /// **'Organization is not approved or cannot login yet'**
  String get orgNotApproved;

  /// No description provided for @orgCheckError.
  ///
  /// In en, this message translates to:
  /// **'Error checking organization'**
  String get orgCheckError;

  /// No description provided for @serverConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Error connecting to server'**
  String get serverConnectionError;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @languageSelection.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get languageSelection;

  /// No description provided for @registrationError.
  ///
  /// In en, this message translates to:
  /// **'Registration error occurred'**
  String get registrationError;

  /// No description provided for @serverConnectionErrorDetail.
  ///
  /// In en, this message translates to:
  /// **'Server connection error'**
  String get serverConnectionErrorDetail;

  /// No description provided for @businessTypeSummary.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get businessTypeSummary;

  /// No description provided for @employeeCountSummary.
  ///
  /// In en, this message translates to:
  /// **'Employee Count'**
  String get employeeCountSummary;

  /// No description provided for @websiteSummary.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get websiteSummary;

  /// No description provided for @descriptionSummary.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionSummary;

  /// No description provided for @noWebsite.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noWebsite;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noDescription;

  /// No description provided for @businessTypeRetailTh.
  ///
  /// In en, this message translates to:
  /// **'Retail'**
  String get businessTypeRetailTh;

  /// No description provided for @businessTypeWholesaleTh.
  ///
  /// In en, this message translates to:
  /// **'Wholesale'**
  String get businessTypeWholesaleTh;

  /// No description provided for @businessTypeManufacturingTh.
  ///
  /// In en, this message translates to:
  /// **'Manufacturing'**
  String get businessTypeManufacturingTh;

  /// No description provided for @businessTypeServiceTh.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get businessTypeServiceTh;

  /// No description provided for @businessTypeTechnologyTh.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get businessTypeTechnologyTh;

  /// No description provided for @businessTypeEducationTh.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get businessTypeEducationTh;

  /// No description provided for @businessTypeHealthcareTh.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get businessTypeHealthcareTh;

  /// No description provided for @businessTypeFinanceTh.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get businessTypeFinanceTh;

  /// No description provided for @businessTypeConstructionTh.
  ///
  /// In en, this message translates to:
  /// **'Construction'**
  String get businessTypeConstructionTh;

  /// No description provided for @businessTypeFoodTh.
  ///
  /// In en, this message translates to:
  /// **'Food & Beverage'**
  String get businessTypeFoodTh;

  /// No description provided for @businessTypeLogisticsTh.
  ///
  /// In en, this message translates to:
  /// **'Logistics'**
  String get businessTypeLogisticsTh;

  /// No description provided for @businessTypeTourismTh.
  ///
  /// In en, this message translates to:
  /// **'Tourism'**
  String get businessTypeTourismTh;

  /// No description provided for @businessTypeOtherTh.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get businessTypeOtherTh;

  /// No description provided for @phoneNumberOnlyError.
  ///
  /// In en, this message translates to:
  /// **'Phone number must contain only numbers'**
  String get phoneNumberOnlyError;

  /// No description provided for @companyRegistrationNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Company Registration Number *'**
  String get companyRegistrationNumberLabel;

  /// No description provided for @companyRegistrationNumberHelperText.
  ///
  /// In en, this message translates to:
  /// **'13-digit company registration number'**
  String get companyRegistrationNumberHelperText;

  /// No description provided for @pleaseEnterCompanyRegistrationNumberTh.
  ///
  /// In en, this message translates to:
  /// **'Please enter company registration number'**
  String get pleaseEnterCompanyRegistrationNumberTh;

  /// No description provided for @taxIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax ID *'**
  String get taxIdLabel;

  /// No description provided for @taxIdHelperText.
  ///
  /// In en, this message translates to:
  /// **'13-digit tax identification number'**
  String get taxIdHelperText;

  /// No description provided for @pleaseEnterTaxIdTh.
  ///
  /// In en, this message translates to:
  /// **'Please enter tax ID'**
  String get pleaseEnterTaxIdTh;

  /// No description provided for @companyRegistrationSummary.
  ///
  /// In en, this message translates to:
  /// **'Company Registration Number'**
  String get companyRegistrationSummary;

  /// No description provided for @taxIdSummary.
  ///
  /// In en, this message translates to:
  /// **'Tax ID'**
  String get taxIdSummary;

  /// No description provided for @addressSummary.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressSummary;

  /// No description provided for @errorRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields.'**
  String get errorRequiredFields;

  /// No description provided for @errorOrgNotFound.
  ///
  /// In en, this message translates to:
  /// **'Organization code not found.'**
  String get errorOrgNotFound;

  /// No description provided for @errorOrgNotApproved.
  ///
  /// In en, this message translates to:
  /// **'Organization is not approved yet.'**
  String get errorOrgNotApproved;

  /// No description provided for @errorOrgSuspended.
  ///
  /// In en, this message translates to:
  /// **'Organization is suspended.'**
  String get errorOrgSuspended;

  /// No description provided for @errorOrgExpired.
  ///
  /// In en, this message translates to:
  /// **'Organization subscription has expired.'**
  String get errorOrgExpired;

  /// No description provided for @errorUserSuspended.
  ///
  /// In en, this message translates to:
  /// **'User account is suspended.'**
  String get errorUserSuspended;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email/employee ID or password.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorLoginError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during login.'**
  String get errorLoginError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
