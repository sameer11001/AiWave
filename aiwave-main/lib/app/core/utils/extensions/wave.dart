import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_core/wave_core.dart';

extension AIModelTypeX on AIModelType {
  Color get color {
    switch (this) {
      case AIModelType.wordWave:
        return const Color(0xffC09FF8);
      case AIModelType.visionWave:
        return const Color(0xffF8C09F);
      case AIModelType.reserachWave:
        return Get.theme.colorScheme.primary;
    }
  }

  IconData get icon {
    switch (this) {
      case AIModelType.wordWave:
        return Icons.ondemand_video;
      case AIModelType.visionWave:
        return Icons.slideshow;
      case AIModelType.reserachWave:
        return Icons.cyclone;
    }
  }
}
