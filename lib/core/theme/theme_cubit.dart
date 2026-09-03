import 'package:barnasht_app/core/services/shared_preferences_singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(_getSavedTheme());

  static const String _themeKey = 'is_dark_mode';

  static ThemeMode _getSavedTheme() {
    final isDarkMode = Prefs.getBool(_themeKey);

    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    emit(newTheme);

    await Prefs.setBool(_themeKey, newTheme == ThemeMode.dark);
  }

  Future<void> setLightTheme() async {
    emit(ThemeMode.light);

    await Prefs.setBool(_themeKey, false);
  }

  Future<void> setDarkTheme() async {
    emit(ThemeMode.dark);

    await Prefs.setBool(_themeKey, true);
  }
}
