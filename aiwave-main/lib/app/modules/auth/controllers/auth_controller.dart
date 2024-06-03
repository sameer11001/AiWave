import 'package:aiwave/app/data/model/user_model.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class AuthController extends GetxController {

  static Future<void> goToHomeView() async {
    // Initialize the UserAccount instance.
    await UserAccount.init();
    Get.offAllNamed(Routes.HOME);
  }

}
