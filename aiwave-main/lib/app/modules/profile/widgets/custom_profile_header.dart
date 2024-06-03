import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/text_theme.dart';
import '../../../data/model/user_model.dart';
import '../../../global_widgets/user_image_widget.dart';
import '../controllers/profile_controller.dart';
import 'update_current_user_dialog.dart';

class CustomProfileHeader extends GetView<ProfileController> {
  const CustomProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25.0),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UserImageWidget(
                        size: 120,
                        onTap: controller.updateUserProfile,
                      ),
                    ),
                    Obx(() {
                      if (controller.isUpdateImage) {
                        return const Positioned.fill(
                          child: CircularProgressIndicator(
                            strokeWidth: 6,
                          ),
                        );
                      }
                      return const SizedBox();
                    })
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Obx(() {
                              return Text(
                                UserAccount.currentUser?.username ??
                                    'user_name'.tr,
                                style: AppStyle.headLine4,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            }),
                          ),
                          IconButton(
                            onPressed: () =>
                                Get.dialog(UpdateCurrentUserDialog()),
                            icon: const Icon(Icons.edit),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        UserAccount.currentUser?.email ?? 'email'.tr,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppStyle.headLine6,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
