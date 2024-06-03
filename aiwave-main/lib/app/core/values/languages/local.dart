import 'package:get/get.dart';

import 'code/ar.dart';
import 'code/en.dart';
import 'code/fr.dart';
import 'code/zh.dart';

class MyTranslations implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "ar": ar,
        "en": en,
        "fr": fr,
        "zh": zh,
      };
}
