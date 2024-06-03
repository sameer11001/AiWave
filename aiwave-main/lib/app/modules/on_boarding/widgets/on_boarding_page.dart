import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/text_theme.dart';
import 'custom_chip_widget.dart';

class OnBoardingPage extends StatelessWidget {
  final String? assestImage;
  final String? title;
  final String? description;
  final ThemeData? data;

  const OnBoardingPage({
    super.key,
    this.description,
    this.data,
    this.assestImage,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Theme(
        data: data ?? Get.theme,
        child: Material(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  // height: Get.height * .45,
                  child: CustomChipWidget(assestImage: assestImage),
                ),
                const SizedBox(height: 30),
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title!.tr,
                      style: AppStyle.headLine2.copyWith(
                        color: Get.theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Text(
                      description!.tr,
                      style: AppStyle.subTitle3.copyWith(
                        color: Get.theme.colorScheme.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: Get.height * .15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
