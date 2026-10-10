import 'package:flutter/material.dart';

abstract class AppColors {
  // ============================================================
  // Brand Colors
  // ============================================================

  /// Main brand green
  static const Color primary = Color(0xFF176B45);

  /// Lighter brand green
  static const Color primaryLight = Color(0xFF4FAF5F);

  /// Deep brand green
  static const Color primaryDark = Color(0xFF0B3D2A);

  /// Logo orange / location pin
  static const Color accent = Color(0xFFF5A623);

  /// Darker orange
  static const Color accentDark = Color(0xFFD98212);

  /// Navigation blue from the logo
  static const Color navigationBlue = Color(0xFF1687C9);

  // ============================================================
  // Light Theme
  // ============================================================

  /// Main screen background
  static const Color lightBackground = Color(0xFFF7F9F7);

  /// Cards / surfaces
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Main text
  static const Color lightText = Color(0xFF18211C);

  /// Secondary text
  static const Color lightSecondaryText = Color(0xFF68736C);

  /// Borders / dividers
  static const Color lightBorder = Color(0xFFE3E8E4);

  /// Background container/chip color for primary elements
  static const Color lightPrimaryContainer = Color(0xFFE5F0E7);

  /// Background container/chip color for accent elements
  static const Color lightAccentContainer = Color(0xFFFFF1DE);

  // ============================================================
  // Dark Theme
  // ============================================================

  /// Main screen background
  static const Color darkBackground = Color(0xFF0B1014);

  /// Cards / place cards in Dark mode.
  /// Slightly lighter than the main background
  /// without feeling detached from it.
  static const Color darkCard = Color(0xFF141C21);

  /// Cards / bottom sheets / dialogs
  static const Color darkSurface = Color(0xFF192127);

  /// Elevated cards / elements that need more visual depth
  static const Color darkSurfaceElevated = Color(0xFF202A32);

  /// Main text
  static const Color darkText = Color(0xFFE9EEF0);

  /// Secondary text
  static const Color darkSecondaryText = Color(0xFF9AA6AE);

  /// Borders / dividers
  static const Color darkBorder = Color(0xFF2B363E);

  /// Soft green for primary highlights / buttons in Dark mode
  static const Color darkPrimary = Color(0xFF65B477);

  /// Text/Icon color to be placed ON TOP of darkPrimary elements
  static const Color darkOnPrimary = Color(0xFF0B3D2A);

  /// Soft orange for accent elements in Dark mode
  static const Color darkAccent = Color(0xFFF2B35B);

  /// Text/Icon color to be placed ON TOP of darkAccent elements
  static const Color darkOnAccent = Color(0xFF3D2300);

  // ============================================================
  // Status Colors
  // ============================================================

  static const Color success = Color(0xFF55B779);

  static const Color warning = Color(0xFFF2B35B);

  static const Color error = Color(0xFFE16B6B);

  static const Color info = Color(0xFF4FA3D1);
}
