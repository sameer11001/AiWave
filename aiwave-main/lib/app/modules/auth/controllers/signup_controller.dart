import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_auth/wave_auth.dart';

import '../../../core/utils/helpers/custom_snack_bar.dart';
import '../../../core/utils/helpers/system_helper.dart';
import '../../../data/repositorys/auth_repository.dart';
import '../../../routes/app_pages.dart';
import 'auth_controller.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  bool isAccepted = false;

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.onInit();
  }

  Future<void> onSignUpPressed() async {
    SystemHelper.closeKeyboard();

    final isValidForm = formKey.currentState!.validate();
    if (isValidForm == false) return;

    if (isAccepted == false) {
      CustomSnackBar.warning(
        title: 'tearms_and_conditions'.tr,
        message: 'tearms_and_conditions_message'.tr,
      );
      return;
    }

    isLoading(true);

    try {
      final User _ = await AuthRepository.signUp(
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
      title: 'coming_soon'.tr,
      message: 'coming_soon_message'.tr,
    );
  }

  void goToSignInView() => Get.offNamed(Routes.SIGNIN);
}
