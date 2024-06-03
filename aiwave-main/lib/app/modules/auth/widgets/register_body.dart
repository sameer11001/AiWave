// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:wave_auth/wave_auth.dart';

import '../../../core/utils/helpers/custom_bottom_sheet.dart';
import '../../../core/utils/helpers/system_helper.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_textformfield.dart';
import '../controllers/register_controller.dart';

class RegisterBody extends GetView<RegisterController> {
  const RegisterBody({super.key});

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
            children: [
              SizedBox(height: Get.height * .05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PickUserImageWidget(
                    onChanged: (imagePath) => controller.imagePath = imagePath,
                  ),
                ],
              ),
              SizedBox(height: Get.height * .06),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: controller.usernameController,
                      label: 'user_name'.tr,
                      autofillHints: const [AutofillHints.username],
                      validator: WaveValidator.validateUsername,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * .06),
              CustomButton(
                label: 'continue'.tr,
                onPressed: controller.onContinuePressed,
              ),
              SizedBox(height: Get.height * .1),
            ],
          ),
        ),
      ),
    );
  }
}

class PickUserImageWidget extends StatefulWidget {
  final ValueChanged<String?>? onChanged;
  const PickUserImageWidget({super.key, this.onChanged});

  @override
  State<PickUserImageWidget> createState() => _PickUserImageWidgetState();
}

class _PickUserImageWidgetState extends State<PickUserImageWidget> {
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            height: 125,
            width: 125,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                width: 5,
                color: Theme.of(context).colorScheme.primary,
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Theme.of(context).colorScheme.primary,
              //     blurRadius: 20,
              //     offset: const Offset(5, 5),
              //   ),
              // ],
            ),
            child: ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(150),
              child: image?.path != null
                  ? Image.file(
                      File(image!.path),
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.person, size: 100),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              height: 40,
              width: 29,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: () async {
                  final res = await CustomBottomSheet.imagePiker();
                  if (res != null) {
                    setState(() => image = res);
                    widget.onChanged?.call(res.path);
                  }
                },
                child: const Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
