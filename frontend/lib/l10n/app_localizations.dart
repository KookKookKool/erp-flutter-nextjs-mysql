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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th')
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

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

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

  /// No description provided for @employeeListTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee List'**
  String get employeeListTitle;

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
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'th': return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
