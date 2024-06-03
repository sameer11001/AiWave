import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../controllers/aysel_wave_controller.dart';

class SendTextFormField extends GetView<AyselWaveController> {
  const SendTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(
        () {
          return TextField(
            controller: controller.textController,
            enabled: !controller.isLoading,
            cursorColor: Theme.of(context).colorScheme.primary,
            style: const TextStyle(color: Colors.grey),
            onChanged: controller.onChanged,
            onSubmitted: (value) {
              controller.sendMessage();
            },
            decoration: InputDecoration(
              border: disabledBorder(),
              focusedBorder: activeBorder(),
              hintText: "message".tr,
              suffixIcon: suffixWidget(),
              prefixIcon: prefixWidget(),
            ),
          );
        },
      ),
    );
  }

  Obx suffixWidget() {
    return Obx(
      () {
        if (controller.showMicIcon.value) {
          return GestureDetector(
            onTap: controller.openMic,
            child: Icon(
              controller.isListening ? Icons.mic : Icons.mic_off,
              color: Colors.grey,
            ),
          );
        } else {
          return GestureDetector(
            onTap: controller.sendMessage,
            child: Transform.rotate(
              angle: -math.pi / 4.0,
              child: const Icon(
                Icons.send_outlined,
                color: Colors.grey,
              ),
            ),
          );
        }
      },
    );
  }

  OutlineInputBorder activeBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(
        color: Get.theme.colorScheme.primary,
      ),
    );
  }

  OutlineInputBorder disabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(
        color: Get.theme.colorScheme.onBackground,
      ),
    );
  }

  Widget prefixWidget() {
    return IconButton(
      onPressed: () => controller.toggleResearchSource(),
      tooltip: controller.isArchive ? "arxiv".tr : "wikipedia".tr,
      icon: Icon(
        controller.isArchive ? Icons.book : FontAwesomeIcons.wikipediaW,
        color: Colors.grey,
        size: 18.0,
      ),
    );
  }
}
