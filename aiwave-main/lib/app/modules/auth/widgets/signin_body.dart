import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_auth/wave_auth.dart';

import '../../../core/utils/helpers/system_helper.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_textformfield.dart';
import '../../../global_widgets/logo_widget.dart';
import '../controllers/signin_controller.dart';

class SigninBody extends GetView<SigninController> {
  const SigninBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SystemHelper.closeKeyboard(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: Get.width,
        height: Get.height,
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const LogoWidgetWithLabel(
                height: 100,
                width: 100,
              ),
              SizedBox(height: Get.height * .06),
              Text(
                "sign_in_to_your_account".tr,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall,
              ),
              SizedBox(height: Get.height * .11),
              CustomTextFormField(
                controller: controller.emailController,
                prefixIcon: const Icon(Icons.email),
                label: "email".tr,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: WaveValidator.validateEmail,
                required: true,
              ),
              SizedBox(height: Get.height * .01),
              CustomTextFormField(
                controller: controller.passwordController,
                prefixIcon: const Icon(Icons.password),
                label: "password".tr,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.email],
                required: true,
                isPassword: true,
              ),
              SizedBox(height: Get.height * .15),
              CustomButton(
                label: "sign_in".tr,
                onPressed: controller.onSignInPressed,
              ),
              SizedBox(height: Get.height * .01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('do_not_have_an_account'.tr),
                  TextButton(
                    onPressed: controller.goToSignUpView,
                    child: Text('sign_up'.tr),
                  )
                ],
              ),
              SizedBox(height: Get.height * .1),
            ],
          ),
        ),
      ),
    );
  }
}
