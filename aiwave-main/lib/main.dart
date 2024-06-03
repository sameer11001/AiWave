import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/values/consts.dart';

import 'app/core/values/languages/local.dart';
import 'app/core/values/languages/local_controler.dart';
import 'app/data/database/local_database.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: LocalDatabase.getTheme,
      builder: (context, myTheme) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstant.appName,
          themeMode: myTheme.brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          locale: LocaleController.getLang,
          translations: MyTranslations(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}

Future<void> initServices() async {
  await GetStorage.init();
}
