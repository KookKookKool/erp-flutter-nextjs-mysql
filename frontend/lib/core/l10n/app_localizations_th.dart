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
  String get leaveAdd => 'ขอลา';

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

  @override
  String get employeeModule => 'พนักงาน';

  @override
  String get attendanceModule => 'บันทึกเวลา';

  @override
  String get payrollModule => 'เงินเดือน';

  @override
  String get leaveModule => 'การลา';

  @override
  String get leaveApprovalModule => 'อนุมัติการลา';

  @override
  String get employeeListTitle => 'รายชื่อพนักงาน';

  @override
  String get employeeListContent => 'เนื้อหารายชื่อพนักงาน';

  @override
  String get attendanceTitle => 'บันทึกเวลาเข้า-ออก';

  @override
  String get attendanceContent => 'เนื้อหาบันทึกเวลาเข้า-ออก';

  @override
  String get payrollTitle => 'เงินเดือน';

  @override
  String get payrollContent => 'เนื้อหาเงินเดือน';

  @override
  String get leaveTitle => 'การลา';

  @override
  String get leaveContent => 'เนื้อหาการลา';

  @override
  String get leaveApprovalTitle => 'อนุมัติการลา';

  @override
  String get leaveApprovalContent => 'เนื้อหาอนุมัติการลา';

  @override
  String get projectTaskModule => 'งานโปรเจ็ค';

  @override
  String get projectTaskContent => 'เนื้อหางานโปรเจ็ค';

  @override
  String get projectStatusModule => 'สถานะงาน';

  @override
  String get projectStatusContent => 'เนื้อหาสถานะงาน';

  @override
  String get projectNotificationModule => 'แจ้งเตือนงาน';

  @override
  String get projectNotificationContent => 'เนื้อหาแจ้งเตือนงาน';

  @override
  String get salesCustomerModule => 'ข้อมูลลูกค้า';

  @override
  String get salesCustomerContent => 'เนื้อหาข้อมูลลูกค้า';

  @override
  String get salesQuotationModule => 'ใบเสนอราคา/ใบสั่งขาย';

  @override
  String get salesQuotationContent => 'เนื้อหาใบเสนอราคา/ใบสั่งขาย';

  @override
  String get salesReportModule => 'รายงานการขาย';

  @override
  String get salesReportContent => 'เนื้อหารายงานการขาย';

  @override
  String get purchasingOrderModule => 'ใบสั่งซื้อ';

  @override
  String get purchasingOrderContent => 'เนื้อหาใบสั่งซื้อ';

  @override
  String get purchasingSupplierModule => 'ซัพพลายเออร์';

  @override
  String get purchasingSupplierContent => 'เนื้อหาซัพพลายเออร์';

  @override
  String get purchasingReportModule => 'รายงานการจัดซื้อ';

  @override
  String get purchasingReportContent => 'เนื้อหารายงานการจัดซื้อ';

  @override
  String get inventoryProductModule => 'สินค้า/วัตถุดิบ';

  @override
  String get inventoryProductContent => 'เนื้อหาสินค้า/วัตถุดิบ';

  @override
  String get inventoryStockModule => 'สต็อกคงเหลือ';

  @override
  String get inventoryStockContent => 'เนื้อหาสต็อกคงเหลือ';

  @override
  String get inventoryTransactionModule => 'รับ-จ่ายสินค้า';

  @override
  String get inventoryTransactionContent => 'เนื้อหารับ-จ่ายสินค้า';

  @override
  String get accountingIncomeModule => 'บัญชีรายรับ-รายจ่าย';

  @override
  String get accountingIncomeContent => 'เนื้อหาบัญชีรายรับ-รายจ่าย';

  @override
  String get accountingFinanceModule => 'งบการเงิน';

  @override
  String get accountingFinanceContent => 'เนื้อหางบการเงิน';

  @override
  String get accountingReportModule => 'รายงานบัญชี';

  @override
  String get accountingReportContent => 'เนื้อหารายงานบัญชี';

  @override
  String get crmCustomerModule => 'ข้อมูลลูกค้า CRM';

  @override
  String get crmCustomerContent => 'เนื้อหาข้อมูลลูกค้า CRM';

  @override
  String get crmHistoryModule => 'ประวัติการติดต่อ';

  @override
  String get crmHistoryContent => 'เนื้อหาประวัติการติดต่อ';

  @override
  String get crmActivityModule => 'กิจกรรมการขาย';

  @override
  String get crmActivityContent => 'เนื้อหากิจกรรมการขาย';

  @override
  String get reportsDashboardModule => 'แดชบอร์ด';

  @override
  String get reportsDashboardContent => 'เนื้อหาแดชบอร์ดวิเคราะห์ข้อมูล';

  @override
  String get settingsUserModule => 'จัดการผู้ใช้';

  @override
  String get settingsUserContent => 'เนื้อหาจัดการผู้ใช้';

  @override
  String get settingsPermissionModule => 'สิทธิ์ผู้ใช้';

  @override
  String get settingsPermissionContent => 'เนื้อหาสิทธิ์ผู้ใช้';

  @override
  String get settingsConfigModule => 'ตั้งค่าระบบ';

  @override
  String get settingsConfigContent => 'เนื้อหาตั้งค่าระบบ';

  @override
  String get settingsNotificationModule => 'ศูนย์แจ้งเตือน';

  @override
  String get settingsNotificationContent => 'เนื้อหาศูนย์แจ้งเตือน';

  @override
  String get rememberMe => 'จดจำการเข้าสู่ระบบ';

  @override
  String get addEmployee => 'เพิ่มพนักงาน';

  @override
  String get editEmployee => 'แก้ไขข้อมูลพนักงาน';

  @override
  String get delete => 'ลบ';

  @override
  String get save => 'บันทึก';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get confirmDelete => 'ยืนยันการลบ';

  @override
  String get confirmDeleteMessage => 'คุณแน่ใจหรือไม่ที่จะลบพนักงานคนนี้?';

  @override
  String get changeImage => 'เปลี่ยนรูปภาพ';

  @override
  String get pickStartDate => 'เลือกวันที่เริ่มงาน';

  @override
  String get searchHint => 'ค้นหาชื่อหรือรหัสพนักงาน';

  @override
  String get position => 'ตำแหน่ง';

  @override
  String get name => 'ชื่อ';

  @override
  String get surname => 'นามสกุล';

  @override
  String get employeeIdLabel => 'รหัสพนักงาน';

  @override
  String get level => 'ระดับ';

  @override
  String get email => 'อีเมล';

  @override
  String get phone => 'เบอร์โทร';

  @override
  String get startDate => 'วันที่เริ่มงาน';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get showPassword => 'แสดงรหัสผ่าน';

  @override
  String get hidePassword => 'ซ่อนรหัสผ่าน';

  @override
  String get otStart => 'เวลา OT เข้า';

  @override
  String get otEnd => 'เวลา OT ออก';

  @override
  String get otRate => 'เรท OT';

  @override
  String get leaveTypeSick => 'ลาป่วย';

  @override
  String get leaveTypePersonal => 'ลากิจ';

  @override
  String get leaveTypeVacation => 'ลาพักร้อน';

  @override
  String get leaveStatusPending => 'รออนุมัติ';

  @override
  String get leaveStatusApproved => 'อนุมัติ';

  @override
  String get leaveStatusRejected => 'ไม่อนุมัติ';

  @override
  String get addLeaveTitle => 'เพิ่มการลา';

  @override
  String get leaveDate => 'วันที่ลา';

  @override
  String get leaveReason => 'เหตุผล';

  @override
  String get leaveSave => 'บันทึก';

  @override
  String get leaveCancel => 'ยกเลิก';

  @override
  String get pleaseSelectLeaveType => 'กรุณาเลือกประเภทการลา';

  @override
  String get pleaseSelectDate => 'กรุณาเลือกวันที่ลา';

  @override
  String get pleaseEnterReason => 'กรุณากรอกเหตุผล';

  @override
  String get leaveTypeLabel => 'ประเภทการลา';
}
