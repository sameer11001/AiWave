import 'package:aiwave/app/core/theme/text_theme.dart';
import 'package:aiwave/app/core/utils/helpers/custom_dialog.dart';
import 'package:aiwave/app/core/utils/helpers/custom_logs.dart';
import 'package:aiwave/app/global_widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_auth/wave_auth.dart';
import 'package:wave_core/wave_core.dart';

import '../../../data/database/local_database.dart';
import '../../../data/model/user_model.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    check();
  }

  Future<void> check() async {
    // Get the ip address from local database. 
    // If the ip address is null, set the ip address to the wave config
    WaveConfig.ipAddress = LocalDatabase.getIPAddress();
    // Check if the server is online
    final online = await checkTheServer();

    // Initialize the wave auth
    await WaveAuth.init();
    // Check if is the first time to open the app
    if (online) {
      LocalDatabase.isFirstTime.printInfo(info: "isFirstTime ");
      if (LocalDatabase.isFirstTime) {
        await Future.delayed(2.seconds);
        Get.offAndToNamed(Routes.SELECTED_LANG);
      } else {
        // Get the ip address from local database

        // Check if the user is already signed in.
        final isLogin = WaveAuth.instance.currentUser != null;
        if (isLogin) {
          // Initialize the UserAccount instance.
          UserAccount.init();
          // Add delay to show splash screen
          await Future.delayed(1.seconds);
          // Navigate to home screen
          Get.offAndToNamed(Routes.HOME);
        } else {
          // Add delay to show splash screen
          await Future.delayed(1.seconds);
          // Navigate to sign in screen
          Get.offAndToNamed(Routes.SIGNIN);
        }
      }
    } else {
      await Future.delayed(1.seconds);
      Get.offAllNamed(Routes.SPLASH);
    }
  }

  Future<bool> checkTheServer() async {
    // Initialize the ip controller. This controller will be used to get the ip address from the user.
    TextEditingController ipController = TextEditingController(
      text: WaveConfig.ipAddress,
    );

    try {
      final waveAuth = WaveAuth.instance;
      final res = await waveAuth.checkServer(receiveTimeout: 3);
      logDebug('${"#" * 25} Server Info ${"#" * 25}');
      res['system_info'].forEach((key, value) {
        logDebug(value);
      });
      logDebug("#" * 63);
      return true;
    } catch (_) {
      await CustomDialog.showDoneDialog(
        title: "The Server is not available",
        barrierDismissible: false,
        body: Column(
          children: [
            Text(
              "Please check your server or change the ip address",
              style: AppStyle.bodyText3,
            ),
            SizedBox(height: Get.height * .02),
            CustomTextFormField(
              label: "IP Address",
              controller: ipController,
            ),
          ],
        ),
        onDonePressed: () async {
          // Get the ip address from the text field and remove the white spaces
          final ip = ipController.text.trim();
          // Set the ip address to the wave config
          WaveConfig.ipAddress = ip;
          // Save the ip address to local database
          await LocalDatabase.setIPAddress(ip);
        },
      );
      return false;
    }
  }
}
