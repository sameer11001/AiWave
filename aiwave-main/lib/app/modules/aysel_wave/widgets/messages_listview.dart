import 'package:aiwave/app/core/utils/helpers/system_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/aysel_wave_controller.dart';
import 'message_widget.dart';

class MessagesListView extends GetView<AyselWaveController> {
  const MessagesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SystemHelper.closeKeyboard(),
      child: GetBuilder<AyselWaveController>(
        id: 'messages',
        builder: (_) {
          return Obx(() {
            return ListView.builder(
              controller: controller.scrollController,
              itemCount: controller.isAlpha
                  ? controller.insightfulMessages.length
                  : controller.talksMessages.length,
              itemBuilder: (context, index) {
                final message = controller.isAlpha
                    ? controller.insightfulMessages[index]
                    : controller.talksMessages[index];

                if (controller.isAlpha) {
                  return MessageDocWidget(message: message);
                } else {
                  return MessageTextWidget(message: message);
                }
              },
            );
          });
        },
      ),
    );
  }
}
