// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../data/database/local_database.dart';

abstract class LocaleController {
  static List<LanguageItem> get supportedLanguages {
    return [
      LanguageItem(
        locale: const Locale('en'),
        name: 'english',
        icons: Icons.g_translate,
      ),
      LanguageItem(
        locale: const Locale('ar'),
        name: 'arabic',
        icons: FontAwesomeIcons.earthAmericas,
      ),
      LanguageItem(
        locale: const Locale('fr'),
        name: 'french',
        icons: FontAwesomeIcons.earthEurope,
      ),
      LanguageItem(
        locale: const Locale('zh'),
        name: 'chinese',
        icons: Icons.translate,
      ),
    ];
  }

  static get getLang {
    final lCode = LocalDatabase.languageCode;
    Locale lang = Locale(lCode);

    return lang;
  }

  static void changeLang(String codelang) {
    LocalDatabase.languageCode = codelang;
    Locale locale = Locale(codelang);
    Get.updateLocale(locale);
  }
}

class LanguageItem {
  final Locale locale;
  final String name;
  final IconData? icons;

  LanguageItem({
    required this.locale,
    required this.name,
    this.icons,
  });
}
