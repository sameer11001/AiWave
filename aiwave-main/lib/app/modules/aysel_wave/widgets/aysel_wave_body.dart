import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/helpers/system_helper.dart';
import '../../../global_widgets/wave_background.dart';
import '../controllers/aysel_wave_controller.dart';
import 'messages_listview.dart';
import 'send_textformfield.dart';
import 'toggle.dart';
import 'welcome_aysel_wave.dart';

class AyselWaveBody extends GetView<AyselWaveController> {
  const AyselWaveBody({super.key});

  @override
  Widget build(BuildContext context) {
    return WaveBackground(
      child: GestureDetector(
        onTap: () => SystemHelper.closeKeyboard(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Toggle(),
            const Divider(),
            SizedBox(height: Get.height * .005),
            Expanded(
              child: Obx(() {
                // Check if the messages list is empty
                bool isEmpty = controller.isAlpha
                    ? controller.insightfulMessages.isEmpty
                    : controller.talksMessages.isEmpty;
                return isEmpty
                    ? const WelcomeAyselWave()
                    : const MessagesListView();
              }),
            ),
            const SendTextFormField(),
          ],
        ),
      ),
    );
  }
}
