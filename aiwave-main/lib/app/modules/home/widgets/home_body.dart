import 'package:aiwave/app/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/wave_background.dart';
import '../controllers/home_controller.dart';
import 'history_list_view.dart';
import 'wave_ai_cards.dart';

class HomeBody extends GetView<HomeController> {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return WaveBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: kToolbarHeight + Get.height * .05,
          ),
          Text(
            "welcome_message".tr,
            style: AppStyle.headLine3.copyWith(),
          ),
          SizedBox(height: Get.height * .05),
          SizedBox(
            height: Get.height * .3,
            child: const WaveAICards(),
          ),
          const SizedBox(height: 16.0),
          const Expanded(
            child: HistoryListView(),
          )
        ],
      ),
    );
  }
}
