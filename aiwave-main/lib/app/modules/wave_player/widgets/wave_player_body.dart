import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/wave_player_controller.dart';
import 'video_view_widget.dart';
import 'wave_player_chat.dart';
import 'wave_player_header.dart';
import 'wave_player_objects.dart';

class WavePlayerBody extends GetView<WavePlayerController> {
  const WavePlayerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const VideoViewWidget(),
          SizedBox(height: Get.height * .025),
          const WavePlayerHeader(),
          const Divider(),
          SizedBox(
            height: Get.height * .45,
            child: Obx(
              () {
                return Visibility(
                  visible: controller.isVisible,
                  child: controller.subtitleList != null
                      ? const WavePlayerChat()
                      : const WavePlayerObjects(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
