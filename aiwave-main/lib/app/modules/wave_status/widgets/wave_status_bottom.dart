import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:wave_ai/wave_ai.dart';

import '../../../core/utils/helpers/custom_dialog.dart';
import '../controllers/wave_status_controller.dart';

class WaveStatusBottomWidget extends GetView<WaveStatusController> {
  const WaveStatusBottomWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Builder(builder: (context) {
        //   return FloatingActionButton(
        //     onPressed: () {
        //       Scaffold.of(context).openDrawer();
        //     },
        //     mini: true,
        //     heroTag: 'list-button',
        //     backgroundColor: const Color(0xffC09FF8),
        //     child: const Icon(
        //       Icons.list,
        //     ),
        //   );
        // }),
        ClipRRect(
          borderRadius: BorderRadius.circular(350.0),
          child: controller.status.state == StatusState.completed
              ? null
              : RippleAnimation(
                  color: Theme.of(context).colorScheme.primary,
                  delay: const Duration(milliseconds: 300),
                  repeat: true,
                  duration: const Duration(milliseconds: 6 * 300),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Material(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground,
                          width: 2.0,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          CustomDialog.showDoneDialog(
                            title: 'Note',
                            content:
                                'The wave is still processing on the server, You can close the app and check the result later.',
                            onDonePressed: () => Get.back(),
                          );
                        },
                        icon: const Icon(
                          Icons.home,
                          size: 48.0,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        // FloatingActionButton(
        //   onPressed: () {
        //     CustomDialog.showDoneDialog(
        //         title: 'Note',
        //         content:
        //             'The wave is still processing on the server, You can close the app and check the result later.',
        //         onDonePressed: () => Get.back());
        //   },
        //   mini: true,
        //   heroTag: 'close-button',
        //   backgroundColor: Colors.grey,
        //   child: const Icon(
        //     Icons.close,
        //   ),
        // ),
      ],
    );
  }
}
