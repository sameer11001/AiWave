import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_auth/wave_auth.dart';

import '../../../core/utils/helpers/custom_snack_bar.dart';
import '../../../core/utils/helpers/system_helper.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  late User? user;

  late TextEditingController usernameController;

  String? imagePath;

  @override
  void onInit() {
    usernameController = TextEditingController();

    user = Get.arguments['user'];

    super.onInit();
  }

  Future<void> onContinuePressed() async {
    SystemHelper.closeKeyboard();
    final isValidForm = formKey.currentState!.validate();
    if (isValidForm == false) return;
    if (imagePath == null || imagePath!.isEmpty) {
      CustomSnackBar.warning(
        title: 'profile_picture'.tr,
        message: 'select_image'.tr,
      );
      return;
    }

    isLoading(true);

    try {
      // final uuid = user!.uid;
      // final imageUrl = await FirebaseImage.uploadUserImage(
      //   imagePath: imagePath!,
      //   uuid: uuid,
      // );

      // UserAccount userAccount = UserAccount(
      //   uuid: uuid,
      //   username: usernameController.text,
      //   imageUrl: imageUrl!,
      //   phoneNumber: user!.phoneNumber ?? '',
      // );

      // await UserFirebase.setUser(userAccount: userAccount);

      // UserAccount.currentUser = userAccount;

      // await UserAccount.init();
      // await PlaceProvider.init();
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      CustomSnackBar.error(message: e.toString());
    }

    isLoading(false);
  }
}
