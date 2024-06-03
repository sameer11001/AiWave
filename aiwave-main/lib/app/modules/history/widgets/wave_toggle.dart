import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/text_theme.dart';
import '../controllers/history_controller.dart';

class WaveToggle extends GetView<HistoryController> {
  const WaveToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .08,
      padding: const EdgeInsets.all(8.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.grey.withOpacity(.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        primary: true,
        scrollDirection: Axis.horizontal,
        children: [
          ToggleButton(
            idx: 0,
            label: 'processes'.tr,
          ),
          const SizedBox(width: 12.0),
          ToggleButton(
            idx: 1,
            label: 'media'.tr,
          ),
        ],
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final int idx;
  final String label;
  const ToggleButton({super.key, required this.idx, required this.label});

  @override
  Widget build(BuildContext context) {
    return GetX<HistoryController>(
      builder: (controller) {
        final isSelected = controller.selectedIndex == idx;
        return SizedBox(
          width: Get.width * .3,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: isSelected ? const Color(0xFF303033) : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => controller.onViewSelected(idx),
            child: Text(
              label.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodyText3.copyWith(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        );
      },
    );
  }
}
