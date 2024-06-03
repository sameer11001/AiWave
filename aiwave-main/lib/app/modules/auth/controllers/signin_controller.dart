import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_auth/wave_auth.dart';

import '../../../core/utils/helpers/custom_snack_bar.dart';
import '../../../core/utils/helpers/system_helper.dart';
import '../../../data/repositorys/auth_repository.dart';
import '../../../routes/app_pages.dart';
import 'auth_controller.dart';

class SigninController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void onInit() {
    // TODO: Remove this after testing
    const index = 0;
    emailController = TextEditingController(text: 'test$index@wave.com');
    passwordController = TextEditingController(text: 'Password$index@');
    super.onInit();
  }

  Future<void> onSignInPressed() async {
    SystemHelper.closeKeyboard();

    final isValidForm = formKey.currentState!.validate();
    if (isValidForm == false) return;

    isLoading(true);

    try {
      final User _ = await AuthRepository.signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      await AuthController.goToHomeView();
    } on WaveAuthException catch (error) {
      CustomSnackBar.waveAuthException(error);
    } catch (e) {
      CustomSnackBar.error(message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  void comingSoon() {
    CustomSnackBar.defaultSnackBar(
      title: "coming_soon".tr,
      message: 'coming_soon_message'.tr,
    );
  }

  void goToSignUpView() => Get.offNamed(Routes.SIGNUP);
}
