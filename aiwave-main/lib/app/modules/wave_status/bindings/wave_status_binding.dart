import 'package:get/get.dart';

import '../controllers/wave_status_controller.dart';

class WaveStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaveStatusController>(
      () => WaveStatusController(),
    );
  }
}
