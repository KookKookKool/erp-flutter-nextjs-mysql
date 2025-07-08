# Announcement Module

โมดูลย่อยสำหรับจัดการประกาศในระบบ HRM พร้อมการแสดงผลในหน้า Home

## โครงสร้างไฟล์

```
announcement/
├── models/
│   └── announcement.dart          # โมเดลข้อมูลประกาศ
├── bloc/
│   └── announcement_cubit.dart    # การจัดการ state ด้วย Cubit
├── widgets/
│   ├── announcement_card.dart     # การ์ดแสดงประกาศ
│   ├── announcement_search_bar.dart # แถบค้นหาประกาศ
│   └── add_announcement_dialog.dart # ไดอะล็อกเพิ่ม/แก้ไขประกาศ
├── announcement_screen.dart       # หน้าจอหลักของประกาศ
├── announcement_repository.dart   # จัดการข้อมูลประกาศ
├── announcement_module.dart       # Export ทั้งหมด
└── README.md                      # คู่มือใช้งาน
```

## Home Page Integration

นอกจากโมดูลหลักแล้ว ยังมี widgets สำหรับแสดงใน Home Page:

```
widgets/home/
├── hr_announcement.dart           # แสดงประกาศล่าสุดในหน้า Home
├── home_announcement_card.dart    # การ์ดประกาศสำหรับหน้า Home
├── announcement_summary.dart      # สรุปจำนวนประกาศตามระดับความสำคัญ
└── urgent_announcement_banner.dart # แบนเนอร์ประกาศด่วน
```

## ฟีเจอร์หลัก

### โมดูลประกาศหลัก
1. **แสดงรายการประกาศ** - แสดงประกาศทั้งหมดพร้อมรายละเอียด
2. **ค้นหาประกาศ** - ค้นหาประกาศจากหัวข้อ, เนื้อหา, หรือผู้เขียน
3. **เพิ่มประกาศ** - สร้างประกาศใหม่ด้วยระดับความสำคัญ
4. **แก้ไขประกาศ** - แก้ไขประกาศที่มีอยู่
5. **ลบประกาศ** - ลบประกาศด้วยการยืนยัน
6. **ระดับความสำคัญ** - กำหนดระดับความสำคัญ (สูง, ปานกลาง, ต่ำ)

### การแสดงผลในหน้า Home
1. **🚨 แบนเนอร์ประกาศด่วน** - แสดงประกาศสำคัญมากที่ต้องแจ้งเตือน
2. **📊 สถิติประกาศ** - สรุปจำนวนประกาศตามระดับความสำคัญ
3. **📋 ประกาศล่าสุด** - แสดงประกาศ 3 รายการล่าสุด
4. **🔗 การนำทางแบบเชื่อมต่อ** - คลิกเพื่อไปยังโมดูลประกาศ

## การแสดงผลใน Home Page

### UrgentAnnouncementBanner
แบนเนอร์สำหรับแสดงประกาศด่วนที่มีความสำคัญสูง:
```dart
const UrgentAnnouncementBanner()
```

### AnnouncementSummary
สถิติประกาศแยกตามระดับความสำคัญ:
```dart
const AnnouncementSummary()
```

### HrAnnouncement
แสดงประกาศล่าสุด 3 รายการพร้อมปุ่ม "ดูทั้งหมด":
```dart
const HrAnnouncement()
```

### HomeAnnouncementCard
การ์ดประกาศที่ออกแบบพิเศษสำหรับหน้า Home:
```dart
HomeAnnouncementCard(
  announcement: announcement,
  onTap: () => // Navigate to announcement module
)
```

## โมเดลข้อมูล

### Announcement
- `id`: รหัสประกาศ (String)
- `title`: หัวข้อประกาศ (String)
- `content`: เนื้อหาประกาศ (String)
- `createdDate`: วันที่สร้าง (DateTime)
- `author`: ผู้เขียน (String)
- `priority`: ระดับความสำคัญ (AnnouncementPriority)
- `isActive`: สถานะใช้งาน (bool)

### AnnouncementPriority (Enum)
- `high`: ความสำคัญสูง (สีแดง)
- `medium`: ความสำคัญปานกลาง (สีส้ม)
- `low`: ความสำคัญต่ำ (สีน้ำเงิน)

## การใช้งาน

### 1. Import โมดูล
```dart
import 'package:frontend/modules/hrm/announcement/announcement_module.dart';
```

### 2. ใช้งาน AnnouncementScreen
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AnnouncementScreen(),
  ),
);
```

### 3. ใช้งาน BlocProvider
```dart
BlocProvider<AnnouncementCubit>(
  create: (_) => AnnouncementCubit(announcementRepository),
  child: const AnnouncementScreen(),
)
```

## State Management

ใช้ **Cubit** สำหรับจัดการ state ของประกาศ:

- `AnnouncementState`: เก็บรายการประกาศ, สถานะโหลด, ข้อผิดพลาด, และคำค้นหา
- `AnnouncementCubit`: จัดการการเปลี่ยนแปลง state และเรียกใช้ repository

## Repository Pattern

`AnnouncementRepository` จัดการข้อมูลประกาศ:
- `getAllAnnouncements()`: ดึงประกาศทั้งหมด
- `addAnnouncement()`: เพิ่มประกาศใหม่
- `updateAnnouncement()`: อัปเดตประกาศ
- `deleteAnnouncement()`: ลบประกาศ
- `searchAnnouncements()`: ค้นหาประกาศ

## Widgets หลัก

### AnnouncementCard
การ์ดแสดงประกาศพร้อมเมนูตัวเลือก (แก้ไข/ลบ)

### AnnouncementSearchBar
แถบค้นหาประกาศด้วยปุ่มเคลียร์

### AddAnnouncementDialog
ไดอะล็อกสำหรับเพิ่มและแก้ไขประกาศ

## การแปลภาษา

รองรับภาษาไทยและอังกฤษผ่าน `AppLocalizations`

## ตัวอย่างการใช้งาน

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnnouncementCubit(
        context.read<AnnouncementRepository>(),
      ),
      child: const AnnouncementScreen(),
    );
  }
}
```
