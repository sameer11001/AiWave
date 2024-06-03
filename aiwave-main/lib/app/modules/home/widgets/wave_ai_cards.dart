import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_core/wave_core.dart';

import '../../../core/theme/text_theme.dart';
import '../../../global_widgets/custom_card.dart';
import '../../../routes/app_pages.dart';
import '../../history/views/history_view.dart';

class WaveAICards extends StatelessWidget {
  const WaveAICards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: WaveCard(
            icons: Icons.cyclone,
            title: Text(
              'aysel_wave'.tr,
              style: AppStyle.bodyText1.copyWith(
                color: Colors.black,
              ),
            ),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () => Get.toNamed(Routes.AYSEL_WAVE),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: WaveCard(
                  icons: Icons.ondemand_video,
                  title: Text(
                    'word_wave'.tr,
                    style: AppStyle.bodyText1.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  color: const Color(0xffC09FF8),
                  onPressed: () {
                    HistoryView.show(
                      modelType: AIModelType.wordWave,
                    );
                  },
                ),
              ),
              const SizedBox(height: 6.0),
              Expanded(
                child: WaveCard(
                  icons: Icons.slideshow,
                  title: Text(
                    'vision_wave'.tr,
                    style: AppStyle.bodyText1.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  color: const Color(0xffFEC4DD),
                  onPressed: () {
                    HistoryView.show(
                      modelType: AIModelType.visionWave,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
