import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/wave_background.dart';
import '../controllers/history_controller.dart';
import 'media_body.dart';
import 'processes_body.dart';
import 'wave_toggle.dart';

class HistoryBody extends GetView<HistoryController> {
  const HistoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    return WaveBackground(
      waveType: WaveBackgroundType.two,
      child: Column(
        children: [
          SizedBox(height: kToolbarHeight + Get.height * .03),
          const WaveToggle(),
          SizedBox(height: Get.height * .025),
          const Divider(),
          SizedBox(height: Get.height * .025),
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ProcessesBody(),
                MediaBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
