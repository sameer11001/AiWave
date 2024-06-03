import 'package:get/get.dart';

import '../controllers/wave_player_controller.dart';

class WavePlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WavePlayerController>(
      () => WavePlayerController(),
    );
  }
}
