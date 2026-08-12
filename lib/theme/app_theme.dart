import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFFDF0EE);
  static const backgroundDark = Color(0xFF241B22);
  static const pinkAccent = Color(0xFFF4A8C0);
  static const purpleAccent = Color(0xFF9A5CB4);
  static const textDark = Color(0xFF2E2430);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.purpleAccent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.pinkAccent,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.purpleAccent,
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.pinkAccent,
        foregroundColor: AppColors.textDark,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.pinkAccent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.pinkAccent,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundDark,
        selectedItemColor: AppColors.pinkAccent,
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.pinkAccent,
        foregroundColor: AppColors.textDark,
      ),
      useMaterial3: true,
    );
  }
}
