import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/utils/helpers/custom_dialog.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icons;
  final VoidCallback? onTap;
  final Color? iconColor;
  const CustomCard({
    super.key,
    required this.title,
    this.onTap,
    this.icons = Icons.g_translate,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: onTap == null
          ? Banner(
              location: BannerLocation.topStart,
              message: 'coming_soon'.tr,
              child: CardBodyWidget(
                onTap: () {
                  CustomDialog.showDoneDialog(
                    title: 'coming_soon'.tr,
                    content: 'this_feature_is_coming_soon'.tr,
                  );
                },
                icons: icons,
                iconColor: iconColor,
                title: title,
              ),
            )
          : CardBodyWidget(
              onTap: onTap,
              icons: icons,
              iconColor: iconColor,
              title: title,
            ),
    );
  }
}

class CardBodyWidget extends StatelessWidget {
  const CardBodyWidget({
    super.key,
    required this.onTap,
    required this.icons,
    required this.iconColor,
    required this.title,
  });

  final VoidCallback? onTap;
  final IconData icons;
  final Color? iconColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      elevation: 8.0,
      height: Get.height * .2,
      color: Get.theme.colorScheme.surface,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icons,
            size: 60,
            color: iconColor ?? Get.theme.colorScheme.onBackground,
          ),
          const SizedBox(height: 8.0),
          Text(
            title.tr,
            style: TextStyle(
              color: Get.theme.colorScheme.onBackground,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class WaveCard extends StatelessWidget {
  final IconData icons;
  final Color? color;
  final Widget title;
  final VoidCallback? onPressed;
  const WaveCard({
    super.key,
    required this.icons,
    required this.title,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(16),
      color: color ?? Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: ShapeDecoration(
                  color: Colors.black.withOpacity(0.20000000298023224),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Icon(
                  icons,
                  color: Colors.black,
                ),
              ),
              const Icon(
                Icons.call_made,
                color: Colors.black,
              )
            ],
          ),
          title,
          
        ],
      ),
    );
  }
}
