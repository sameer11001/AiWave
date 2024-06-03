import 'package:aiwave/app/data/model/user_model.dart';
import 'package:aiwave/app/global_widgets/media_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/history_controller.dart';

class MediaBody extends GetView<HistoryController> {
  const MediaBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AddWaveButton(),
        SizedBox(height: Get.height * .02),
        Expanded(
          child: Obx(() {
            final mediaList = UserAccount.mediaList;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: mediaList.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final media = mediaList[index];
                return MediaCard(
                  media: media,
                  // showControls: false,
                  onPressed: () async {
                    // await controller.onMediaTap(media);
                    await controller.onMediaTap(media);
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class AddWaveButton extends GetView<HistoryController> {
  const AddWaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: Get.height * .1,
      color: Colors.grey.withOpacity(.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: controller.pickFiles,
      child: const Center(
          child: Icon(
        Icons.add,
      )),
    );
  }
}
