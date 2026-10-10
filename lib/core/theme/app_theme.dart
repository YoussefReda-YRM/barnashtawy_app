import 'package:barnasht_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AppTheme {
  // ============================================================
  // Light Theme
  // ============================================================

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.lightBackground,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightText,
    ),

    cardTheme: const CardThemeData(color: AppColors.lightSurface, elevation: 0),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightText,
      elevation: 0,

      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.lightBackground,
        systemNavigationBarColor: AppColors.lightBackground,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
  );

  // ============================================================
  // Dark Theme
  // ============================================================

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    // ==========================================================
    // Main screen background
    // #0B1014
    // ==========================================================
    scaffoldBackgroundColor: AppColors.darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkAccent,

      // Surface is reserved for sheets/dialogs/general surfaces
      // #192127
      surface: AppColors.darkSurface,

      onSurface: AppColors.darkText,
    ),

    // ==========================================================
    // Card color
    // #141C21
    // ==========================================================
    cardTheme: const CardThemeData(color: AppColors.darkCard, elevation: 0),

    appBarTheme: const AppBarTheme(
      // #0B1014
      backgroundColor: AppColors.darkBackground,

      foregroundColor: AppColors.darkText,

      elevation: 0,

      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar
        statusBarColor: AppColors.darkBackground,

        // Navigation bar
        systemNavigationBarColor: AppColors.darkBackground,

        // White status bar icons
        statusBarIconBrightness: Brightness.light,

        // White navigation bar icons
        systemNavigationBarIconBrightness: Brightness.light,

        // Disable Android navigation-bar contrast
        systemNavigationBarContrastEnforced: false,
      ),
    ),
  );
}
