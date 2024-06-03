import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/text_theme.dart';
import '../controllers/wave_status_controller.dart';

class WaveStatusDrawer extends GetView<WaveStatusController> {
  const WaveStatusDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width * .8,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                top: 24.0,
                left: 24.0,
              ),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListView.builder(
                itemCount: controller.status.progress.length,
                primary: true,
                itemBuilder: (context, index) {
                  final item = controller.status.progress[index];
                  return GetBuilder<WaveStatusController>(
                    id: 'progress-${item.step}',
                    builder: (controller) {
                      final item = controller.status.progress[index];
                      return SizedBox(
                        width: double.infinity,
                        child: ListTile(
                          leading: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${item.step}: ",
                                ),
                                TextSpan(
                                  text: '${item.state.toKey().capitalize}',
                                  style: TextStyle(
                                    color: item.state.color,
                                  ),
                                ),
                              ],
                            ),
                            style: AppStyle.bodyText3.copyWith(
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
