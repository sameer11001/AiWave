import 'package:get/get.dart';

import '../controllers/aysel_wave_controller.dart';

class AyselWaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AyselWaveController>(
      () => AyselWaveController(),
    );
  }
}
