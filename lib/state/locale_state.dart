import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Manages app locale (English / Arabic)
class LocaleState extends GetxController {
  final _locale = const Locale('en').obs;

  Locale get locale => _locale.value;
  set locale(Locale value) {
    _locale.value = value;
    Get.updateLocale(value);
  }

  bool get isArabic => _locale.value.languageCode == 'ar';

  void setEnglish() => locale = const Locale('en');
  void setArabic() => locale = const Locale('ar');
  void toggle() => locale = isArabic ? const Locale('en') : const Locale('ar');
}
