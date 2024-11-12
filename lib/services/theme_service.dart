// theme_service.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _storage = GetStorage();
  final _themeKey = 'isDarkMode';

  ThemeMode getThemeMode() {
    return _isDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool _isDarkMode() {
    return _storage.read(_themeKey) ?? false;
  }

  void switchTheme() {
    bool newThemeIsDark = !_isDarkMode();
    Get.changeThemeMode(newThemeIsDark ? ThemeMode.dark : ThemeMode.light);
    _storage.write(_themeKey, newThemeIsDark);
  }
}
