# Payroll Module - ระบบจัดการเงินเดือน

## ฟีเจอร์หลัก

### 📊 การจัดการข้อมูลเงินเดือน
- **เพิ่มพนักงาน**: ซิงค์ข้อมูลจากระบบพนักงาน (รหัส, ชื่อ-นามสกุล)
- **ประเภทเงินเดือน**: รายวัน / รายเดือน
- **จัดการจำนวนเงิน**: กรอกเงินเดือนได้แบบอิสระ
- **แก้ไข/ลบ**: จัดการข้อมูลได้ทุกเมื่อ

### 📄 Export สลิปเงินเดือน PDF
- **เลือกพนักงาน**: สามารถเลือกได้หลายคนพร้อมกัน
- **เลือกทั้งหมด**: ปุ่ม "เลือกทั้งหมด" และ "ยกเลิกทั้งหมด"
- **ส่งออก PDF**: Export สลิปเงินเดือนเป็น PDF ได้

### 🎨 UI/UX Features
- **Responsive Design**: รองรับทั้งมือถือและเดสก์ท็อป
- **Modern Card Layout**: แสดงข้อมูลแบบ Card พร้อม Checkbox
- **Visual Feedback**: แสดง Loading states และ Success/Error messages
- **Pull to Refresh**: ดึงข้อมูลใหม่ได้โดยการ swipe down

## โครงสร้างไฟล์

```
lib/modules/hrm/payroll/
├── models/
│   └── payroll_employee.dart      # Employee & PayrollEmployee models
├── services/
│   └── payroll_service.dart       # API service layer
├── bloc/
│   └── payroll_bloc.dart         # Business logic & state management
├── widgets/
│   ├── payroll_employee_card.dart # Card component
│   ├── add_payroll_dialog.dart   # Add employee dialog
│   └── edit_payroll_dialog.dart  # Edit employee dialog
└── payroll_screen.dart           # Main screen
```

## การใช้งาน

### 1. เพิ่มข้อมูลเงินเดือน
1. กดปุ่ม "+" ใน AppBar
2. เลือกพนักงานจาก dropdown (ข้อมูลซิงค์จากระบบพนักงาน)
3. เลือกประเภท: รายวัน หรือ รายเดือน
4. กรอกจำนวนเงิน (บาท)
5. กด "เพิ่ม"

### 2. แก้ไขข้อมูล
1. กด menu (3 จุด) ที่ card พนักงาน
2. เลือก "แก้ไข"
3. แก้ไขประเภทและจำนวนเงิน
4. กด "บันทึก"

### 3. ส่งออกสลิป PDF
1. เลือกพนักงานโดยกด checkbox
2. หรือกด "เลือกทั้งหมด" เพื่อเลือกทุกคน
3. กดปุ่ม "ส่งออกสลิปเงินเดือน PDF"
4. ยืนยันการส่งออก

## State Management

### PayrollBloc Events
- `LoadPayrollEmployees`: โหลดข้อมูลพนักงานทั้งหมด
- `AddPayrollEmployee`: เพิ่มพนักงานใหม่
- `UpdatePayrollEmployee`: อัปเดตข้อมูลพนักงาน
- `DeletePayrollEmployee`: ลบข้อมูลพนักงาน
- `ToggleEmployeeSelection`: เลือก/ยกเลิกพนักงาน
- `SelectAllEmployees`: เลือกทั้งหมด
- `ClearAllSelection`: ยกเลิกการเลือกทั้งหมด
- `ExportPayslips`: ส่งออก PDF

### PayrollBloc States
- `PayrollInitial`: สถานะเริ่มต้น
- `PayrollLoading`: กำลังโหลดข้อมูล
- `PayrollLoaded`: โหลดข้อมูลเสร็จแล้ว
- `PayrollError`: เกิดข้อผิดพลาด
- `PayrollSuccess`: ดำเนินการสำเร็จ

## Models

### PayrollEmployee
```dart
class PayrollEmployee {
  final String id;
  final String employeeId;    // รหัสพนักงาน
  final String firstName;     // ชื่อ
  final String lastName;      // นามสกุล
  final PayrollType payrollType; // รายวัน/รายเดือน
  final double salary;        // เงินเดือน (บาท)
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### PayrollType Enum
```dart
enum PayrollType {
  daily('รายวัน'),
  monthly('รายเดือน');
}
```

## Service Layer

### PayrollService
- `getAllPayrollEmployees()`: ดึงข้อมูลพนักงานทั้งหมด
- `getAllEmployees()`: ดึงข้อมูลพนักงานจากระบบ
- `getAvailableEmployees()`: ดึงพนักงานที่ยังไม่มีข้อมูลเงินเดือน
- `addPayrollEmployee()`: เพิ่มข้อมูลเงินเดือน
- `updatePayrollEmployee()`: อัปเดตข้อมูล
- `deletePayrollEmployee()`: ลบข้อมูล
- `exportPayslips()`: ส่งออก PDF

## การปรับแต่ง

### เพิ่ม Employee Data Source
ในไฟล์ `payroll_service.dart` สามารถแก้ไข `_allEmployees` เพื่อซิงค์ข้อมูลจาก API จริง:

```dart
Future<List<Employee>> getAllEmployees() async {
  // เรียก API จริงแทน mock data
  final response = await http.get('/api/employees');
  return response.data.map((e) => Employee.fromJson(e)).toList();
}
```

### การ Export PDF
ในไฟล์ `payroll_service.dart` ฟังก์ชัน `exportPayslips()` สามารถใช้ library เช่น `pdf` หรือ `printing` เพื่อสร้าง PDF จริง:

```dart
Future<void> exportPayslips(List<String> employeeIds) async {
  // ใช้ library pdf เพื่อสร้างไฟล์ PDF
  final pdf = pw.Document();
  // ... สร้างเนื้อหา PDF
  await Printing.layoutPdf(onLayout: (format) => pdf.save());
}
```

## การทดสอบ
1. ทดสอบเพิ่มพนักงานที่มีข้อมูลครบถ้วน
2. ทดสอบแก้ไขประเภทเงินเดือนและจำนวนเงิน
3. ทดสอบลบข้อมูลพนักงาน
4. ทดสอบเลือกพนักงานหลายคนและส่งออก PDF
5. ทดสอบ Pull to refresh
6. ทดสอบบนหน้าจอขนาดต่างๆ (mobile/tablet/desktop)
