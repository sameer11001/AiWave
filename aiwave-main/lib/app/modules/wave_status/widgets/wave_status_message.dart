import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/text_theme.dart';
import '../controllers/wave_status_controller.dart';

class WaveStatusMessageWidget extends GetView<WaveStatusController> {
  const WaveStatusMessageWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WaveStatusController>(
      id: 'status-message',
      builder: (controller) {
        return SizedBox(
          height: 48.0,
          child: Text.rich(
            textAlign: TextAlign.center,
            style: AppStyle.bodyText1,
            TextSpan(
              children: [
                TextSpan(
                  text: controller.status.stateMessage,
                ),
                TextSpan(
                  text: ' ${controller.status.state.toKey().capitalize}',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.25),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
