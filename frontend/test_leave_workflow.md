# Test Leave Workflow

## การแก้ไขที่ทำ:
1. **แยก Leave ID ออกจาก Employee ID**: แต่ละ Leave record มี unique ID แยกจาก Employee ID
2. **การสร้าง unique ID**: ใช้ timestamp เพื่อสร้าง unique ID สำหรับแต่ละ leave request
3. **การแสดงผล**: Card แสดง Employee ID แทน Leave ID
4. **การค้นหา**: ค้นหาด้วย Employee ID และ Employee Name

## ไฟล์ที่แก้ไข:
- `leave_repository.dart`: เปลี่ยน Leave model ให้มี employeeId และ employeeName แยกกัน
- `add_leave_dialog.dart`: ใช้ employeeId และ employeeName
- `leave_card.dart`: แสดง employeeId แทน leave id
- `leave_screen.dart`: ค้นหาด้วย employeeId และ employeeName
- `leave_approval_screen.dart`: ค้นหาด้วย employeeId และ employeeName
- `leave_cubit.dart`: จัดการ unique ID สำหรับการเพิ่มใหม่

## การทดสอบที่ควรทำ:
1. **เพิ่มการลาใหม่**: ควรสร้าง unique ID ใหม่ทุกครั้ง
2. **การอนุมัติ/ปฏิเสธ**: ควรอัปเดต status ของ record เดิม
3. **การแสดงในหน้าการลา**: ควรเห็น record ที่ approved/rejected
4. **การค้นหา**: ควรค้นหาได้ด้วย Employee ID และชื่อ
5. **ไม่มีการทับข้อมูล**: พนักงานคนเดียวกันสามารถมีหลาย leave records

## Expected Behavior:
- เมื่อเพิ่มการลาใหม่ → สร้าง record ใหม่ด้วย unique ID
- เมื่ออนุมัติ/ปฏิเสธ → อัปเดต status ของ record เดิม 
- หน้าการลาแสดงทุก records (approved, rejected, pending)
- หน้าอนุมัติแสดงเฉพาะ pending records
- Card แสดง Employee ID ไม่ใช่ Leave ID
