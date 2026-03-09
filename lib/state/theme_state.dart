import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/storage/storage_service.dart';

class ThemeState extends GetxController {
  final _storage = StorageService();
  static const _key = 'theme_mode'; // 'light' | 'dark' | 'system'

  final _themeMode = ThemeMode.dark.obs;
  ThemeMode get themeMode => _themeMode.value;
  set themeMode(ThemeMode v) {
    _themeMode.value = v;
    _save();
    _updateTheme();
  }

  final isDarkMode = true.obs; // Kept for Obx/ThemeToggle - sync in _updateTheme

  bool get _effectiveDark =>
      _themeMode.value == ThemeMode.dark ||
      (_themeMode.value == ThemeMode.system &&
          WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);

  @override
  void onInit() {
    super.onInit();
    final saved = _storage.getString(_key) ?? 'dark';
    _themeMode.value = switch (saved) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };
    isDarkMode.value = _effectiveDark;
    _updateTheme();
  }

  void setLight() => themeMode = ThemeMode.light;
  void setDark() => themeMode = ThemeMode.dark;
  void setSystem() => themeMode = ThemeMode.system;

  void toggleTheme() {
    themeMode = isDarkMode.value ? ThemeMode.light : ThemeMode.dark;
  }

  void _save() {
    final v = switch (_themeMode.value) {
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
      _ => 'dark',
    };
    _storage.saveString(_key, v);
  }

  void _updateTheme() {
    isDarkMode.value = _effectiveDark;
    Get.changeThemeMode(themeMode);
  }
}
