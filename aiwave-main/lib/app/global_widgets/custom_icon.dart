import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomIcon extends StatelessWidget {
  final IconData icons;
  const CustomIcon({super.key, required this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      height: Get.height * .07,
      width: Get.height * .07,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Icon(
        icons,
        size: Get.height * .035,
      ),
    );
  }
}