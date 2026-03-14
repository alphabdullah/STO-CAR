import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/storage/storage_service.dart';

/// Manages app locale (English / Arabic), persisted in SharedPreferences
class LocaleState extends GetxController {
  LocaleState({Locale? initialLocale}) {
    if (initialLocale != null) {
      _locale.value = initialLocale;
    }
  }

  final _locale = const Locale('en').obs;

  Locale get locale => _locale.value;
  set locale(Locale value) {
    _locale.value = value;
    Get.updateLocale(value);
    StorageService().setSelectedLocale(value.languageCode);
  }

  bool get isArabic => _locale.value.languageCode == 'ar';

  void setEnglish() => locale = const Locale('en');
  void setArabic() => locale = const Locale('ar');
  void toggle() => locale = isArabic ? const Locale('en') : const Locale('ar');
}
