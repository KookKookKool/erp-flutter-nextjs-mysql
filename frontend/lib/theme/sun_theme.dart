import 'package:flutter/material.dart';

class SunTheme {
  static const Color sunOrange = Color(0xFFFFA726);
  static const Color sunYellow = Color(0xFFFFD54F);
  static const Color sunLight = Color(0xFFFFF8E1);
  static const Color sunDeepOrange = Color(0xFFF57C00);
  static const Color sunGold = Color(0xFFFFC107);
  static const Color sunRed = Color(0xFFFF7043); // เพิ่มสีแดงอมส้ม
  static const Color sunWhite = Color(0xFFFFFDE7); // ขาวอมเหลือง

  // สีตัวอักษรหลัก/รอง
  static const Color textPrimary = Color(0xFF3E2723); // น้ำตาลเข้ม
  static const Color textSecondary = Color(0xFF795548); // น้ำตาลกลาง
  static const Color textOnGradient = Colors.white; // สำหรับบน gradient

  // Gradient หลัก (พระอาทิตย์จริงจัง)
  static const LinearGradient sunGradient = LinearGradient(
    colors: [
      sunDeepOrange, // ขอบล่าง
      sunOrange, // กลาง
      sunGold, // เหลืองทอง
      sunYellow, // เหลือง
      sunWhite, // ขาวอมเหลือง (ขอบบน)
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: [0.0, 0.3, 0.55, 0.8, 1.0],
  );

  // Gradient รอง (แนวทแยง)
  static const LinearGradient sunGradientDiagonal = LinearGradient(
    colors: [sunDeepOrange, sunRed, sunOrange, sunGold, sunYellow, sunWhite],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    stops: [0.0, 0.18, 0.38, 0.6, 0.82, 1.0],
  );

  // สีสำหรับ widget/card/ปุ่ม ตามที่ใช้ในระบบ
  static const Color cardColor = sunLight;
  static const Color primary = sunOrange;
  static const Color primaryLight = sunYellow;
  static const Color onPrimary = Colors.white;
  static const Color error = Colors.redAccent;

  static ThemeData get themeData => ThemeData(
    primaryColor: sunOrange,
    scaffoldBackgroundColor: sunWhite,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: sunOrange,
      secondary: sunDeepOrange,
    ),
    fontFamily: 'Kanit',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Kanit',
        fontWeight: FontWeight.bold,
        fontSize: 36,
        color: textPrimary,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Kanit',
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: textPrimary,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Kanit',
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Kanit',
        fontSize: 16,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Kanit',
        fontSize: 14,
        color: textSecondary,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Kanit',
        fontSize: 16,
        color: textSecondary,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Kanit',
        fontSize: 14,
        color: textSecondary,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Kanit',
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: sunOrange,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: sunGold,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: sunOrange,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static BoxDecoration get sunSearchBoxDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: primary, width: 1.2),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.10),
        blurRadius: 4,
        spreadRadius: 0.5,
        offset: const Offset(0, 1),
      ),
    ],
  );
}
