import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../../../core/theme/text_theme.dart';
import '../../../global_widgets/custom_list_tile.dart';
import '../../../global_widgets/logo_widget.dart';
import '../../../global_widgets/user_image_widget.dart';
import '../controllers/aysel_wave_controller.dart';
import '../models/message_model.dart';

class MessageTextWidget extends StatelessWidget {
  final Message message;

  const MessageTextWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment:
            message.id == 0 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          circleImage(),
          const SizedBox(height: 12.0),
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Get.theme.colorScheme.onBackground,
                width: 1,
              ),
            ),
            child: GetBuilder<AyselWaveController>(
              id: 'message-${message.uid}',
              builder: (_) {
                if (message.id == 1 || message.text == null) {
                  return Text(
                    message.text ?? "...",
                    style: AppStyle.bodyText3.copyWith(
                      color: Get.theme.colorScheme.onBackground,
                    ),
                  );
                }
                // Change to MarkdownWidget Text style
                return MarkdownWidget(
                  data: message.text!,
                  shrinkWrap: true,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget circleImage() {
    if (message.id == 0) {
      return const LogoWidget(
        margin: 5,
        height: 40,
        width: 40,
      );
    } else {
      return const UserImageWidget();
    }
  }
}

class MessageDocWidget extends StatelessWidget {
  final Message message;

  const MessageDocWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment:
            message.id == 0 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          circleImage(),
          const SizedBox(height: 12.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Get.theme.colorScheme.onBackground,
                width: 1,
              ),
            ),
            child: GetBuilder<AyselWaveController>(
              id: 'message-${message.uid}',
              builder: (_) {
                if (message.id == 1 || message.researchDocs == null) {
                  return Text(
                    message.text ?? "...",
                    style: AppStyle.bodyText3.copyWith(
                      color: Get.theme.colorScheme.onBackground,
                    ),
                  );
                }

                final doc = message.researchDocs!;
                return ResearchItem(
                  doc: doc,
                  enableBorder: false,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget circleImage() {
    if (message.id == 0) {
      return const LogoWidget(
        margin: 5,
        height: 40,
        width: 40,
      );
    } else {
      return const UserImageWidget();
    }
  }
}
