import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wave_ai/wave_ai.dart';
import 'package:wave_storage/wave_storage.dart';

import '../../../routes/app_pages.dart';
import '../widgets/wave_status_body.dart';

class WaveStatusView extends StatelessWidget {
  const WaveStatusView({super.key});

  static Future<AIMedia?> show({required BaseStatus status}) async {
    final data = await Get.toNamed(
      Routes.WAVE_STATUS,
      arguments: status,
    );

    if (data != null) {
      return data as AIMedia;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: true,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // drawer: WaveStatusDrawer(),
        // appBar: WaveStatusAppBar(),
        body: WaveStatusBody(),
      ),
    );
  }
}
