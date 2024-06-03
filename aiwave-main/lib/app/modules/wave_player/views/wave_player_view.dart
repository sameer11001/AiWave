import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:wave_ai/wave_ai.dart';

import '../../../routes/app_pages.dart';
import '../controllers/wave_player_controller.dart';
import '../widgets/wave_player_body.dart';

class WavePlayerView extends GetView<WavePlayerController> {
  const WavePlayerView({super.key});

  static Future<dynamic> show({
    required String videoUrl,
    String? title,
    List<Map<String, dynamic>>? subtitleList,
    ObjectsInfo? objectsInfo,
    VideoPlayerController? videoPlayerController,
  }) async {
    final arguments = {
      'videoUrl': videoUrl,
      'title': title,
      'subtitleList': subtitleList,
      'objectsInfo': objectsInfo,
      'videoPlayerController': videoPlayerController,
    };
    Get.toNamed(Routes.WAVE_PLAYER, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            controller.title?.split('.').first ?? 'wave_player'.tr,
          ),
        ),
        body: const WavePlayerBody(),
      ),
    );
  }
}
