import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wave_ai/wave_ai.dart';
import 'package:wave_storage/wave_storage.dart';

import '../../../data/repositorys/auth_repository.dart';
import '../../../global_widgets/cached_network_image_util.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_dropdown_button.dart';
import '../../theme/text_theme.dart';
import '../../values/languages/local_controler.dart';

class CustomDialog {
  static Future<bool?> showYesNoDialog({
    required String title,
    required String content,
    IconData? icons,
    Color? iconsColor,
    String? yesButtonText,
    String? noButtonText,
    VoidCallback? onYesPressed,
    VoidCallback? onNoPressed,
    Color? yesButtonColor,
    Color? noButtonColor,
    bool barrierDismissible = true,
    Widget? body,
  }) async {
    return await Get.dialog<bool>(
      AlertDialog(
        titlePadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        backgroundColor: Get.theme.colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: Get.theme.colorScheme.onBackground.withOpacity(.2),
            width: 2.0,
          ),
        ),
        title: Column(
          children: [
            Text(
              title,
              style: AppStyle.headLine2,
            ),
            const SizedBox(height: 35.0),
            body ??
                Text(
                  content,
                  style: AppStyle.headLine4,
                  textAlign: TextAlign.center,
                ),
            const SizedBox(height: 35.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  CustomButton(
                    label: yesButtonText ?? 'yes'.tr,
                    backgroundColor:
                        yesButtonColor ?? Get.theme.colorScheme.primary,
                    onPressed: () {
                      Get.back(result: true);
                      onYesPressed?.call();
                    },
                  ),
                  const SizedBox(height: 10.0),
                  CustomButton(
                    foregroundColor: Get.theme.colorScheme.onBackground,
                    label: noButtonText ?? 'no'.tr,
                    backgroundColor:
                        noButtonColor ?? Get.theme.colorScheme.background,
                    onPressed: () {
                      Get.back(result: false);
                      onNoPressed?.call();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<bool?> showDoneDialog({
    required String title,
    String? content,
    final Widget? body,
    final String? doneButtonText,
    final VoidCallback? onDonePressed,
    bool barrierDismissible = true,
  }) async {
    return await Get.dialog<bool>(
      AlertDialog(
        titlePadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8.0,
              ),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                border: Border.all(
                  color: Get.theme.colorScheme.onBackground.withOpacity(.2),
                  width: 2.0,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppStyle.headLine2,
                  ),
                  const SizedBox(height: 35.0),
                  body ??
                      Text(
                        content ?? 'content'.tr,
                        style: AppStyle.headLine4,
                        textAlign: TextAlign.center,
                      ),
                  const SizedBox(height: 35.0),
                ],
              ),
            ),
            const SizedBox(height: 4.0),
            MaterialButton(
              minWidth: double.infinity,
              padding: const EdgeInsets.all(12.0),
              color: Get.theme.colorScheme.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12.0),
                ),
              ),
              onPressed: () {
                Get.back(result: true);
                onDonePressed?.call();
              },
              child: Text(
                doneButtonText ?? 'done'.tr,
                style: AppStyle.button.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> showSignOutDialog() async {
    await showYesNoDialog(
      title: 'sign_out'.tr,
      content: 'sign_out_message'.tr,
      yesButtonText: 'no_thanks'.tr,
      onYesPressed: () => Get.back(),
      noButtonText: 'yes_log_me_out'.tr,
      noButtonColor: Colors.transparent,
      onNoPressed: () async {
        Get.back();
        await AuthRepository.signOut();
      },
    );
  }

  static Future<void> changeLanguage() {
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Get.theme.colorScheme.onBackground.withOpacity(.2),
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'select_language'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: LocaleController.supportedLanguages.length,
                itemBuilder: (context, index) {
                  final lang = LocaleController.supportedLanguages[index];
                  return ListTile(
                    selected: LocaleController.getLang == lang.locale,
                    leading: Icon(lang.icons),
                    title: Text(lang.name.tr),
                    onTap: () {
                      Get.back();
                      LocaleController.changeLang(lang.locale.languageCode);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<Map<String, dynamic>?> showWordWaveDialog({
    required AIMedia media,
  }) async {
    Language language = Language.auto;
    WordWaveTask task = WordWaveTask.defaultTask;

    return await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Get.height * .34,
              child: Stack(
                children: [
                  Positioned.fill(
                    top: Get.height * .065,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Get.theme.cardColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(height: Get.height * .07),
                          CustomDropdownButton(
                            value: task,
                            items: WordWaveTask.values
                                .map(
                                  (e) => DropdownMenuItem<WordWaveTask>(
                                    value: e,
                                    child: Text(e.toKey().tr),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              task = value!;
                            },
                          ),
                          SizedBox(height: Get.height * .04),
                          CustomDropdownButton(
                            value: Language.auto,
                            withSearchBox: true,
                            items: Language.values
                                .map(
                                  (e) => DropdownMenuItem<Language>(
                                    value: e,
                                    child: Text(e.toKey().tr),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              language = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.height * .1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: media.thumbnailUrl ?? '',
                            fit: BoxFit.cover,
                            height: Get.height * .12,
                            width: Get.width * .35,
                            progressIndicatorBuilder: (context, url, download) {
                              return LoadingLogo(download: download);
                            },
                            errorWidget: (context, url, error) {
                              return const ErrorNetworkWidget();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            CustomButton(
              label: 'continue'.tr,
              backgroundColor: Colors.green,
              onPressed: () {
                final data = {
                  'media': media,
                  'language': language,
                  'task': task,
                };
                Get.back(result: data);
              },
            ),
            const SizedBox(height: 12.0),
            CustomButton(
              label: 'cancel'.tr,
              backgroundColor: Get.theme.cardColor.withOpacity(.8),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  static Future<Map<String, dynamic>?> showVisionWaveDialog({
    required AIMedia media,
  }) async {
    VisionObject classes = VisionObject.all;
    VisionWaveTask task = VisionWaveTask.detect;

    return await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Get.height * .34,
              child: Stack(
                children: [
                  Positioned.fill(
                    top: Get.height * .065,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Get.theme.cardColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(height: Get.height * .07),
                          CustomDropdownButton(
                            value: task,
                            items: VisionWaveTask.values
                                .map(
                                  (e) => DropdownMenuItem<VisionWaveTask>(
                                    value: e,
                                    child: Text(e.toKey().tr),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              task = value!;
                            },
                          ),
                          // CustomMultiSelection(
                          //   items: VisionObject.values
                          //       .map(
                          //         (e) => MultiSelectItem<VisionObject>(
                          //           value: e,
                          //           label: e.toKey().tr,
                          //         ),
                          //       )
                          //       .toList(),
                          // ),
                          SizedBox(height: Get.height * .04),
                          CustomDropdownButton(
                            value: classes,
                            withSearchBox: true,
                            items: VisionObject.values
                                .map(
                                  (e) => DropdownMenuItem<VisionObject>(
                                    value: e,
                                    child: Text(e.toKey().tr),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              classes = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.height * .1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: media.thumbnailUrl ?? '',
                            fit: BoxFit.cover,
                            height: Get.height * .12,
                            width: Get.width * .35,
                            progressIndicatorBuilder: (context, url, download) {
                              return LoadingLogo(download: download);
                            },
                            errorWidget: (context, url, error) {
                              return const ErrorNetworkWidget();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            CustomButton(
              label: 'continue'.tr,
              backgroundColor: Colors.green,
              onPressed: () {
                final data = {
                  'media': media,
                  'classes': [classes],
                  'task': task,
                };
                Get.back(result: data);
              },
            ),
            const SizedBox(height: 12.0),
            CustomButton(
              label: 'cancel'.tr,
              backgroundColor: Get.theme.cardColor.withOpacity(.8),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
