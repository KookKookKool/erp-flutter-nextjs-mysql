// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

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
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

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
}
