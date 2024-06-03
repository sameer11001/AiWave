// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_auth/wave_auth.dart';

import '../../../core/theme/text_theme.dart';
import '../../../core/utils/helpers/system_helper.dart';
import '../../../data/model/user_model.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_textformfield.dart';

class UpdateCurrentUserDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final nameController =
      TextEditingController(text: UserAccount.currentUser!.username);
  final ageController = TextEditingController(
      text: UserAccount.currentUser!.age?.toString() ?? '');

  UpdateCurrentUserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "edit_profile".tr,
                      style: AppStyle.headLine2,
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                CustomTextFormField(
                  controller: nameController,
                  label: "user_name".tr,
                  validator: WaveValidator.validateUsername,
                ),
                const SizedBox(height: 12.0),
                CustomTextFormField(
                  controller: ageController,
                  label: "age".tr,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.birthday],
                  validator: WaveValidator.validateAge,
                ),
                const SizedBox(height: 30.0),
                CustomFutureButton(
                  label: Text(
                    'update'.tr,
                    style: AppStyle.button.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.green,
                  onPressed: () async {
                    SystemHelper.closeKeyboard();

                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final waveAuth = WaveAuth.instance;
                      await waveAuth.updateUser(
                        username: nameController.text,
                        age: int.tryParse(ageController.text),
                      );
                      Get.back(result: true);
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                CustomButton(
                  label: 'cancel'.tr,
                  foregroundColor: Get.theme.colorScheme.onBackground,
                  backgroundColor: Get.theme.colorScheme.background,
                  onPressed: () {
                    Get.back(result: false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
