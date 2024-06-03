import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_auth/wave_auth.dart';

import '../../../core/utils/helpers/system_helper.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_check_box.dart';
import '../../../global_widgets/custom_textformfield.dart';
import '../../../global_widgets/logo_widget.dart';
import '../controllers/signup_controller.dart';

class SignupBody extends GetView<SignupController> {
  const SignupBody({super.key});

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
              SizedBox(height: Get.height * .05),
              Text(
                "sign_up_to_your_account".tr,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall,
              ),
              SizedBox(height: Get.height * .05),
              CustomTextFormField(
                controller: controller.emailController,
                prefixIcon: const Icon(Icons.email),
                label: "email".tr,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: WaveValidator.validateEmail,
                required: true,
              ),
              SizedBox(height: Get.height * .03),
              CustomTextFormField(
                controller: controller.passwordController,
                prefixIcon: const Icon(Icons.password),
                label: "password".tr,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.email],
                required: true,
                isPassword: true,
              ),
              const SizedBox(height: 8.0),
              CustomTextFormField(
                controller: controller.confirmPasswordController,
                prefixIcon: const Icon(Icons.password),
                label: "password".tr,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.email],
                required: true,
                isPassword: true,
                withLabel: false,
                validator: (value) {
                  return WaveValidator.confirmPassword(
                    value,
                    controller.passwordController.text,
                  );
                },
              ),
              SizedBox(height: Get.height * .05),
              CustomCheckBox(
                text: 'accept_all_terms_and_conditions'.tr,
                initialValue: controller.isAccepted,
                onChanged: (isChecked) {
                  controller.isAccepted = isChecked;
                },
              ),
              SizedBox(height: Get.height * .01),
              CustomButton(
                label: 'sign_up'.tr,
                onPressed: controller.onSignUpPressed,
              ),
              SizedBox(height: Get.height * .01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('do_you_have_an_account'.tr),
                  TextButton(
                    onPressed: controller.goToSignInView,
                    child: Text('sign_in'.tr),
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
