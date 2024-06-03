import 'package:aiwave/app/core/utils/extensions/wave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wave_ai/wave_ai.dart';
import 'package:wave_auth/wave_auth.dart';
import 'package:wave_storage/wave_storage.dart';

import '../../../core/theme/text_theme.dart';
import '../../../core/values/consts.dart';
import '../../../data/model/user_model.dart';
import '../../../global_widgets/custom_list_tile.dart';
import '../../history/controllers/history_controller.dart';
import '../controllers/home_controller.dart';

class HistoryListView extends GetView<HomeController> {
  const HistoryListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "history".tr,
                style: AppStyle.headLine4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: Material(
              child: controller.items.isEmpty
                  ? Lottie.asset(
                      AppConstant.ghost,
                      height: double.infinity,
                      width: double.infinity,
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.items.length,
                      itemBuilder: (context, index) {
                        final item = controller.items[index];

                        if (item is BaseProcess) {
                          final processUid = item.uid;
                          final mediaList = UserAccount.mediaList;

                          // Get the media based on the proceess_uid
                          final media = mediaList.firstWhere((media) {
                            return media.aiProcesses
                                .any((process) => process.uid == processUid);
                          });

                          return WaveTile(
                            icons: item.modelType.icon,
                            title: media.fileName,
                            url: media.fileUrl,
                            color: item.modelType.color,
                            onTap: () async {
                              final controller = HistoryController();
                              controller.modelType = item.modelType;
                              await controller.onProcessTap(media);
                            },
                            onDeleteTap: () {
                              WaveAuth.instance.deleteMedia(
                                uid: UserAccount.currentUser!.uid,
                                mediaUid: media.uid,
                              );
                              controller.items.removeAt(index);
                              UserAccount.mediaList.remove(media);
                              Get.back();
                            },
                            onDownlodTap: () {
                              WaveStorage.instance.downloadMedia(
                                uid: UserAccount.currentUser!.uid,
                                urlPath: media.fileUrl,
                                fileName: media.fileName,
                              );
                              Get.back();
                            },
                          );
                        } else if (item is ResearchDocs) {
                          return WaveTile(
                            icons: item.modelType.icon,
                            title: item.fileName,
                            url: item.fileUrl,
                            color: Get.theme.colorScheme.primary,
                            onTap: () async {},
                            onDownlodTap: () {
                              WaveStorage.instance.downloadMedia(
                                uid: UserAccount.currentUser!.uid,
                                urlPath: item.fileUrl,
                                fileName: item.fileName,
                              );
                              Get.back();
                            },
                          );
                        } else {
                          return const Center(child: Text("Errors"));
                        }
                      },
                    ),
            ),
          ),
        ],
      );
    });
  }
}
