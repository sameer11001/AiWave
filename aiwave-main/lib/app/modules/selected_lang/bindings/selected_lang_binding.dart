import 'package:get/get.dart';

import '../controllers/selected_lang_controller.dart';

class SelectedLangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectedLangController>(
      () => SelectedLangController(),
    );
  }
}
