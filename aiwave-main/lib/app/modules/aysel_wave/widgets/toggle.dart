import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/text_theme.dart';
import '../controllers/aysel_wave_controller.dart';

class Toggle extends GetView<AyselWaveController> {
  const Toggle({super.key});

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
            label: 'talks'.tr,
            isAlphaSelected: false,
          ),
          const SizedBox(width: 12.0),
          ToggleButton(
            idx: 1,
            label: 'insightful'.tr,
            isAlphaSelected: true,
          ),
        ],
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final int idx;
  final bool? isAlphaSelected;
  final String label;
  const ToggleButton({
    super.key,
    required this.idx,
    required this.label,
    this.isAlphaSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<AyselWaveController>(
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
            onPressed: () {
              controller.onViewSelected(idx);
              controller.isAlpha = isAlphaSelected!;
            },
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
