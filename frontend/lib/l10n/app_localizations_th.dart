// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'ซัน อีอาร์พี';

  @override
  String get orgCodePrompt => 'กรุณากรอกรหัสองค์กร';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get registerOrg => 'สมัครการใช้งานองค์กร';

  @override
  String get employee => 'พนักงาน';

  @override
  String get noEmployees => 'ไม่พบข้อมูลพนักงาน';

  @override
  String get error => 'เกิดข้อผิดพลาด';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get home => 'หน้าหลัก';

  @override
  String get hrm => 'บุคลากร';

  @override
  String get project => 'โครงการ';

  @override
  String get purchasing => 'จัดซื้อ';

  @override
  String get sales => 'ขาย';

  @override
  String get inventory => 'คลังสินค้า';

  @override
  String get accounting => 'บัญชี';

  @override
  String get reports => 'รายงาน';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get selectLanguage => 'เลือกภาษา';

  @override
  String get orgCodeLabel => 'รหัสองค์กร';

  @override
  String get username => 'ชื่อผู้ใช้';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get forgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get employeeName => 'ชื่อพนักงาน';

  @override
  String get employeePosition => 'ตำแหน่งงาน';

  @override
  String employeeId(Object id) {
    return 'รหัสพนักงาน: $id';
  }

  @override
  String get checkIn => 'ลงเวลาเข้า';

  @override
  String get checkOut => 'ลงเวลาออก';

  @override
  String get leave => 'ขอลา';

  @override
  String get taskTitle => 'งานที่เกี่ยวข้องของคุณ';

  @override
  String get taskItem => 'งาน: อัปเดตข้อมูลลูกค้า';

  @override
  String get projectTitle => 'โปรเจ็ค';

  @override
  String get projectDetail => 'CRM System';

  @override
  String get hrAnnouncement => 'ประกาศจาก HR';

  @override
  String get hrAnnouncementTitle => 'แจ้งวันหยุดประจำปี';

  @override
  String get hrAnnouncementSubtitle => 'บริษัทจะหยุดทำการวันที่ 12-15 เมษายน';
}
