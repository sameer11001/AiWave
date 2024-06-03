import 'package:aiwave/app/global_widgets/loading_widget.dart';
import 'package:aiwave/app/modules/history/widgets/history_body.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wave_core/wave_core.dart';

import '../../../global_widgets/upload_stack.dart';
import '../../../routes/app_pages.dart';
import '../controllers/history_controller.dart';
import '../widgets/history_appbar.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  static show({
    required AIModelType modelType,
  }) {
    final arguments = {
      'modelType': modelType,
    };
    Get.toNamed(Routes.HISTORY, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    return UploadStack(
      child: LoadingWidget(
        isLoading: controller.isProcessing,
        child: const Scaffold(
          extendBodyBehindAppBar: true,
          appBar: HistoryAppBar(),
          body: HistoryBody(),
        ),
      ),
    );
  }
}
