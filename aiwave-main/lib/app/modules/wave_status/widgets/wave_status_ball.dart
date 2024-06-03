import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/values/consts.dart';
import '../controllers/wave_status_controller.dart';

class WaveStatusBallWidget extends GetView<WaveStatusController> {
  const WaveStatusBallWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      AppConstant.waveBall2,
      height: Get.height * .4,
      width: Get.width,
    );
  }
}
