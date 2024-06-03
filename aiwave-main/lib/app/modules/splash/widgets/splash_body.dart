import 'package:aiwave/app/core/theme/text_theme.dart';
import 'package:aiwave/app/global_widgets/wave_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/values/consts.dart';
import '../../../global_widgets/logo_widget.dart';

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 0,
          right: 0,
          child: WaveTwo(),
        ),
        Positioned.fill(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: kToolbarHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: Get.height * .03,
                    width: Get.width * .4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      "splash_screen_title".tr,
                      style: AppStyle.bodyText3.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
              const AnimatedLogoWidgetWithLabel(),
              Lottie.asset(
                AppConstant.loading,
                fit: BoxFit.cover,
                height: Get.height * .2,
                width: double.infinity,
              ),
              const Spacer(flex: 1),
            ],
          ),
        )
      ],
    );
  }
}
