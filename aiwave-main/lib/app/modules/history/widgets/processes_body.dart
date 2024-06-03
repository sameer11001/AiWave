import 'package:aiwave/app/data/model/user_model.dart';
import 'package:aiwave/app/global_widgets/media_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_storage/wave_storage.dart';

import '../controllers/history_controller.dart';

class ProcessesBody extends GetView<HistoryController> {
  const ProcessesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final mediaList = UserAccount.mediaList.filterByModelType(controller.modelType);
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
              onPressed: () async {
                await controller.onProcessTap(media);
                
              },
            );
          },
        );
      },
    );
  }
}
