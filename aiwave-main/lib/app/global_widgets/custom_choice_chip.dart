import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/text_theme.dart';

class CustomChoiceChip extends StatelessWidget {
  final String? label;
  final IconData? icons;
  final bool selected;
  final String? assetsImage;
  final ValueChanged<bool>? onChange;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final double borderRadius;
  const CustomChoiceChip({
    super.key,
    required this.selected,
    this.onChange,
    this.label,
    this.icons,
    this.assetsImage,
    this.margin,
    this.child,
    this.borderRadius = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange?.call(!selected);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        alignment: Alignment.center,
        margin: margin ?? const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: selected ? Get.theme.colorScheme.primary : Colors.transparent,
          border: Border.all(
            color: Get.theme.colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected || icons != null)
              Icon(
                selected ? Icons.check_circle : icons,
                size: 16,
                color: selected ? Colors.white : Get.theme.colorScheme.primary,
              ),
            if (!selected && assetsImage != null) Image.asset(assetsImage!),
            if (selected || icons != null || assetsImage != null)
              const SizedBox(width: 4.0),
            if (label != null || child != null)
              if (child != null)
                child!
              else
                Text(
                  label!.tr,
                  style: AppStyle.bodyText4.copyWith(
                    color:
                        selected ? Colors.white : Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
