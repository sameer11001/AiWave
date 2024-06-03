import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/theme/app_theme.dart';

abstract class LocalDatabase {
  static final GetStorage _box = GetStorage();

  static ThemeData get getTheme {
    final isDarkMode = _box.read('isDarkMode') ?? true;

    log('isDarkMode: $isDarkMode');

    return isDarkMode ? AppTheme.dark : AppTheme.light;
  }

  static Future<void> setTheme(bool val) async {
    await _box.write("isDarkMode", val);
    log('isDarkMode: $val');
  }

  static bool get isFirstTime {
    final check = _box.read('isFirstTime') ?? true;
    return check;
  }

  static set isFirstTime(bool val) {
    _box.write("isFirstTime", val);
  }

  static String get languageCode {
    final check = _box.read('languageCode') ?? 'en';
    return check;
  }

  static set languageCode(String val) {
    _box.write("languageCode", val);
  }

  static bool get howToUse {
    final check = _box.read('howToUse') ?? true;
    return check;
  }

  static set howToUse(bool val) {
    _box.write("howToUse", val);
  }

  static String getIPAddress() {
    final check = _box.read('ipAddress') ?? 'http://10.0.2.2';
    return check;
  }

  static Future<void> setIPAddress(String val) async {
    await _box.write("ipAddress", val);
  }
}
