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
  String get announcementModule => 'ประกาศ';

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
  String get salesReportContent => 'เนื้อหารายงานบัญชี';

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

  @override
  String get saveError => 'ไม่สามารถบันทึกคำขอลาได้ กรุณาลองอีกครั้ง.';

  @override
  String get otSelectRate => 'เลือกรอบ OT';

  @override
  String get otApprove => 'อนุมัติ';

  @override
  String get otReject => 'ปฏิเสธ';

  @override
  String get otRequest => 'คำขอ OT';

  @override
  String get otMultiSelect => 'เลือกหลายรายการ';

  @override
  String get otCancelMultiSelect => 'ยกเลิกเลือกหลายรายการ';

  @override
  String get otSelectAll => 'เลือกทั้งหมด';

  @override
  String get otDeselectAll => 'ยกเลิกเลือกทั้งหมด';

  @override
  String otSelectedCount(Object count) {
    return 'เลือกแล้ว $count รายการ';
  }

  @override
  String get otNoRequests => 'ไม่พบคำขอ OT';

  @override
  String get otNoPendingRequests => 'ไม่มีคำขอ OT ที่รอดำเนินการ';

  @override
  String get approve => 'อนุมัติ';

  @override
  String get reject => 'ปฏิเสธ';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get otStatusPending => 'รออนุมัติ';

  @override
  String get otStatusApproved => 'อนุมัติแล้ว';

  @override
  String get otStatusRejected => 'ปฏิเสธ';

  @override
  String otReason(Object reason) {
    return 'เหตุผล: $reason';
  }

  @override
  String otApprovedWithRate(Object rate) {
    return 'อนุมัติแล้ว (เรท x$rate)';
  }

  @override
  String get otApproveButton => 'อนุมัติ';

  @override
  String get otRejectButton => 'ปฏิเสธ';

  @override
  String get otSelectRateTitle => 'เลือกเรท OT';

  @override
  String otApproveOf(Object name) {
    return 'อนุมัติ OT ของ $name';
  }

  @override
  String get otCancel => 'ยกเลิก';

  @override
  String get payrollEdit => 'แก้ไข';

  @override
  String get payrollNoSearchResultTitle => 'ไม่พบผลลัพธ์';

  @override
  String payrollNoSearchResultDescription(Object query) {
    return 'ไม่พบพนักงานที่ตรงกับ \"$query\" ลองค้นหาด้วยชื่อหรือรหัสอื่น';
  }

  @override
  String payrollLastUpdated(Object date) {
    return 'แก้ไขล่าสุด: $date';
  }

  @override
  String get otHourShort => 'ชม.';

  @override
  String get payrollSearchHint => 'ค้นหาพนักงาน (ชื่อ หรือ รหัสพนักงาน)';

  @override
  String get payrollLoading => 'กำลังโหลดข้อมูลเงินเดือน...';

  @override
  String get payrollExporting => 'กำลังส่งออก PDF...';

  @override
  String payrollExport(Object count) {
    return 'ส่งออก PDF ($count คน)';
  }

  @override
  String payrollExportConfirm(Object count) {
    return 'ต้องการส่งออก PDF สำหรับ $count คนหรือไม่?';
  }

  @override
  String get payrollExported => 'ส่งออกสลิปเงินเดือนสำเร็จ!';

  @override
  String get payrollNoData => 'ยังไม่มีข้อมูลเงินเดือน';

  @override
  String get payrollNoDataDescription =>
      'เริ่มต้นโดยการเพิ่มข้อมูลเงินเดือนของพนักงานเพื่อจัดการและส่งออกสลิปเงินเดือน';

  @override
  String get payrollAdd => 'เพิ่มข้อมูลเงินเดือน';

  @override
  String get payrollNoAvailableEmployee => 'ไม่มีพนักงานที่ใช้ได้';

  @override
  String get payrollNoAvailableEmployeeToAdd => 'ไม่มีพนักงานที่สามารถเพิ่มได้';

  @override
  String get payrollExportPayslipTitle => 'ส่งออกสลิปเงินเดือน';

  @override
  String payrollAllSelected(Object count) {
    return 'เลือกพนักงานเพื่อส่งออกสลิป ($count คนที่พบ)';
  }

  @override
  String get payrollSelectAll => 'เลือกทั้งหมด';

  @override
  String get payrollClearSelection => 'ยกเลิก';

  @override
  String payrollSelectedCount(Object selected, Object total) {
    return 'เลือกแล้ว $selected จาก $total คน';
  }

  @override
  String get payrollMultiSelectHint => 'สามารถเลือกหลายคนได้';

  @override
  String get payrollError => 'เกิดข้อผิดพลาดในการโหลดข้อมูล';

  @override
  String get payrollTryAgain => 'ลองใหม่';

  @override
  String get payrollDeleteConfirm => 'ยืนยันการลบ';

  @override
  String payrollDeleteConfirmMsg(Object name) {
    return 'คุณต้องการลบข้อมูลเงินเดือนของ \"$name\" หรือไม่?';
  }

  @override
  String get payrollDelete => 'ลบ';

  @override
  String get payrollClose => 'ปิด';

  @override
  String get payrollTypeLabel => 'ประเภท:';

  @override
  String get payrollTypeMonthly => 'รายเดือน';

  @override
  String get payrollTypeDaily => 'รายวัน';

  @override
  String payrollType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'monthly': 'รายเดือน',
      'daily': 'รายวัน',
      'other': 'ไม่ระบุ',
    });
    return '$_temp0';
  }

  @override
  String get payrollSalary => 'เงินเดือน:';

  @override
  String get payrollCreatedAt => 'สร้างเมื่อ:';

  @override
  String get payrollLastUpdatedLabel => 'แก้ไขล่าสุด:';

  @override
  String payrollNoSearchResult(Object query) {
    return 'ไม่พบพนักงานที่ตรงกับ \"$query\" ลองค้นหาด้วยชื่อหรือรหัสอื่น';
  }

  @override
  String get payrollClearSearch => 'ล้างการค้นหา';

  @override
  String get payrollNoEmployeeData =>
      'พนักงานทั้งหมดมีข้อมูลเงินเดือนแล้ว หรือยังไม่มีข้อมูลพนักงานในระบบ';

  @override
  String get payrollSocialSecurity => 'ประกันสังคม';

  @override
  String get payrollSocialSecurityLabel => 'จำนวนเงินประกันสังคม';

  @override
  String get payrollSocialSecurityHint => 'กรอกจำนวนเงินประกันสังคม';

  @override
  String get payrollSalaryLabel => 'จำนวนเงินเดือน';

  @override
  String get payrollSalaryHintMonthly => 'เช่น 25000';

  @override
  String get payrollSalaryHintDaily => 'เช่น 500';

  @override
  String get payrollSalaryRequired => 'กรุณากรอกจำนวนเงินเดือน';

  @override
  String get payrollSalaryInvalid => 'จำนวนเงินเดือนไม่ถูกต้อง';

  @override
  String get payrollBaht => 'บาท';

  @override
  String get payrollSocialSecurityInvalid => 'จำนวนเงินประกันสังคมไม่ถูกต้อง';

  @override
  String get connectionError =>
      'เกิดข้อผิดพลาดในการเชื่อมต่อ กรุณาลองใหม่อีกครั้ง';

  @override
  String get success => 'สำเร็จ';

  @override
  String get ok => 'ตกลง';

  @override
  String get newMemberRegistration => 'สมัครสมาชิกองค์กรใหม่';

  @override
  String get previousStep => 'ขั้นตอนก่อนหน้า';

  @override
  String get nextStep => 'ขั้นตอนถัดไป';

  @override
  String get submitRequest => 'ส่งคำขอ';

  @override
  String get organizationInfo => 'ข้อมูลองค์กร';

  @override
  String get orgName => 'ชื่อองค์กร *';

  @override
  String get pleaseEnterOrgName => 'กรุณากรอกชื่อองค์กร';

  @override
  String get orgCode => 'รหัสองค์กร *';

  @override
  String get codeForLogin => 'รหัสสำหรับเข้าสู่ระบบ';

  @override
  String get pleaseGenerateOrgCode => 'กรุณาสร้างรหัสองค์กร';

  @override
  String get generateNewCode => 'สร้างรหัสใหม่';

  @override
  String get orgEmail => 'อีเมลองค์กร *';

  @override
  String get pleaseEnterEmail => 'กรุณากรอกอีเมล';

  @override
  String get invalidEmailFormat => 'รูปแบบอีเมลไม่ถูกต้อง';

  @override
  String get orgPhone => 'หมายเลขโทรศัพท์ *';

  @override
  String get pleaseEnterPhone => 'กรุณากรอกหมายเลขโทรศัพท์';

  @override
  String get orgAddress => 'ที่อยู่ *';

  @override
  String get pleaseEnterAddress => 'กรุณากรอกที่อยู่';

  @override
  String get orgDescription => 'รายละเอียด *';

  @override
  String get pleaseEnterDescription => 'กรุณากรอกรายละเอียด';

  @override
  String get adminInfo => 'ข้อมูลผู้ดูแลระบบ';

  @override
  String get adminDescription => 'บุคคลนี้จะเป็นผู้ดูแลระบบขององค์กรของคุณ';

  @override
  String get adminName => 'ชื่อผู้ดูแลระบบ *';

  @override
  String get pleaseEnterAdminName => 'กรุณากรอกชื่อผู้ดูแลระบบ';

  @override
  String get adminEmail => 'อีเมลผู้ดูแลระบบ *';

  @override
  String get passwordRequirement => 'อย่างน้อย 6 ตัวอักษร';

  @override
  String get pleaseEnterPassword => 'กรุณากรอกรหัสผ่าน';

  @override
  String get passwordTooShort => 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';

  @override
  String get confirmPassword => 'ยืนยันรหัสผ่าน *';

  @override
  String get pleaseConfirmPassword => 'กรุณายืนยันรหัสผ่าน';

  @override
  String get passwordMismatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get confirmationInfo => 'ข้อมูลยืนยัน';

  @override
  String get note => 'หมายเหตุ';

  @override
  String get waitingApprovalNote =>
      'คำขอสมัครของคุณได้ถูกส่งแล้วและกำลังรออนุมัติจากทีมผู้ดูแล คุณจะได้รับอีเมลแจ้งเตือนเมื่อได้รับการอนุมัติ';

  @override
  String get businessTypeLabel => 'ประเภทธุรกิจ *';

  @override
  String get businessTypeRetail => 'ค้าปลีก';

  @override
  String get businessTypeWholesale => 'ค้าส่ง';

  @override
  String get businessTypeManufacturing => 'ผลิต';

  @override
  String get businessTypeService => 'บริการ';

  @override
  String get businessTypeTechnology => 'เทคโนโลยี';

  @override
  String get businessTypeEducation => 'การศึกษา';

  @override
  String get businessTypeHealthcare => 'สุขภาพ';

  @override
  String get businessTypeFinance => 'การเงิน';

  @override
  String get businessTypeConstruction => 'ก่อสร้าง';

  @override
  String get businessTypeFood => 'อาหารและเครื่องดื่ม';

  @override
  String get businessTypeLogistics => 'โลจิสติกส์';

  @override
  String get businessTypeTourism => 'ท่องเที่ยว';

  @override
  String get businessTypeOther => 'อื่นๆ';

  @override
  String get pleaseSelectBusinessType => 'กรุณาเลือกประเภทธุรกิจ';

  @override
  String get employeeCountLabel => 'จำนวนพนักงาน *';

  @override
  String get employeeCount_1_10 => '1-10 คน';

  @override
  String get employeeCount_11_50 => '11-50 คน';

  @override
  String get employeeCount_51_100 => '51-100 คน';

  @override
  String get employeeCount_101_500 => '101-500 คน';

  @override
  String get employeeCount_501_1000 => '501-1000 คน';

  @override
  String get employeeCount_1000plus => 'มากกว่า 1000 คน';

  @override
  String get pleaseSelectEmployeeCount => 'กรุณาเลือกจำนวนพนักงาน';

  @override
  String get websiteLabel => 'เว็บไซต์';

  @override
  String get websiteInvalidFormat =>
      'เว็บไซต์ต้องขึ้นต้นด้วย http:// หรือ https://';

  @override
  String get pleaseEnterOrgCode => 'กรุณากรอกรหัสองค์กร';

  @override
  String get invalidOrgCode => 'รหัสองค์กรไม่ถูกต้อง';

  @override
  String get orgNotFound => 'ไม่พบรหัสองค์กรนี้ในระบบ';

  @override
  String get orgNotApproved => 'องค์กรยังไม่สามารถเข้าใช้งานได้';

  @override
  String get orgCheckError => 'เกิดข้อผิดพลาดในการตรวจสอบองค์กร';

  @override
  String get serverConnectionError => 'เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์';

  @override
  String get back => 'ย้อนกลับ';

  @override
  String get languageSelection => 'เลือกภาษา';
}
