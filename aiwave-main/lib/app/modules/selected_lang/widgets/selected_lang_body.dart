import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/text_theme.dart';
import '../../../core/values/languages/local_controler.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/logo_widget.dart';
import '../../../routes/app_pages.dart';
import '../controllers/selected_lang_controller.dart';
import 'language_card.dart';

class SelectedLangBody extends StatelessWidget {
  const SelectedLangBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          const LogoWidget(),
          SizedBox(height: Get.height * 0.1),
          Text(
            "select_language".tr,
            style: AppStyle.headLine3,
          ),
          const SizedBox(height: 25),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: LocaleController.supportedLanguages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                final lang = LocaleController.supportedLanguages[index];
                return GetBuilder<SelectedLangController>(
                  id: 'language_card',
                  builder: (controller) {
                    return LanguageCard(
                      title: lang.name,
                      icons: lang.icons,
                      checked: lang.locale == LocaleController.getLang,
                      onChange: (_) {
                        LocaleController.changeLang(lang.locale.languageCode);
                        controller.update(['language_card']);
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "*${"change_lang_later".tr}",
            style: AppStyle.bodyText3.copyWith(
              color: Get.theme.colorScheme.secondary,
            ),
          ),
          const Spacer(),
          CustomButton(
            label: 'save'.tr,
            onPressed: () => Get.offNamed(Routes.ON_BOARDING),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
