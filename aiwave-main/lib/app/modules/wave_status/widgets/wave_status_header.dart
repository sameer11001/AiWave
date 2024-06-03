
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/text_theme.dart';
import '../controllers/wave_status_controller.dart';

class WaveStatusHeader extends GetView<WaveStatusController> {
  const WaveStatusHeader({
    super.key
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          height: Get.height * .03,
          width: Get.width * .4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            controller.status.modelName
                .replaceAll("_", " ")
                .toUpperCase(),
            style: AppStyle.bodyText3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '•',
              textAlign: TextAlign.center,
              style: AppStyle.bodyText3.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Online',
              textAlign: TextAlign.center,
              style: AppStyle.bodyText4.copyWith(
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ],
        )
      ],
    );
  }
}
