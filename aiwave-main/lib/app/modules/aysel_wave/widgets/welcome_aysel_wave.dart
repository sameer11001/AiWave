import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/logo_widget.dart';
import '../controllers/aysel_wave_controller.dart';

class WelcomeAyselWave extends GetView<AyselWaveController> {
  const WelcomeAyselWave({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Get.height * .08,
        ),
        Obx(
          () {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: controller.isAlpha
                  ? Stack(
                      key: UniqueKey(),
                      children: [
                        LogoWidget(
                          key: UniqueKey(),
                        ),
                        const Positioned(
                          bottom: 15,
                          right: 15,
                          child: Icon(
                            Icons.verified,
                            size: 35,
                          ),
                        )
                      ],
                    )
                  : LogoWidget(
                      key: UniqueKey(),
                    ),
            );
          },
        ),
        Text(
          'aysel_welcome_message'.tr,
          style: Theme.of(context).textTheme.headlineSmall,
        )
      ],
    );
  }
}
