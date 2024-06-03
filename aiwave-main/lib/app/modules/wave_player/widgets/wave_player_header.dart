import 'package:aiwave/app/global_widgets/custom_choice_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/text_theme.dart';
import '../controllers/wave_player_controller.dart';

class WavePlayerHeader extends GetView<WavePlayerController> {
  const WavePlayerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                (controller.title ?? 'wave_player'.tr).split('.').first,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.headLine3,
              ),
            ),
            IconButton(
              onPressed: () => controller.toggleSubtitleChat(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).cardColor,
                ),
              ),
              icon: Obx(
                () => Icon(
                  controller.isVisible
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                ),
              ),
            )
          ],
        ),

        /// Objects List
        if (controller.objectsInfo != null) const ObjectsListWidget(),
      ],
    );
  }
}

class ObjectsListWidget extends GetView<WavePlayerController> {
  const ObjectsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final objectsCount = controller.objectsInfo?.objectsCount ?? 0;
    final objectNames = controller.objectsInfo?.objectNames ?? [];
    return SizedBox(
      height: Get.height * .055,
      width: double.infinity,
      child: Row(
        children: [
          CustomChoiceChip(
            selected: false,
            label: objectsCount.toString(),
            icons: Icons.filter_list,
            borderRadius: 4.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: objectNames.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final objectName = objectNames[index];
                return CustomChoiceChip(
                  selected: false,
                  label: objectName,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
