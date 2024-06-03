import 'package:aiwave/app/core/utils/helpers/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../global_widgets/custom_card.dart';
import '../../theme/text_theme.dart';

class CustomBottomSheet {
  static Future<XFile?> imagePiker({
    String title = 'choses_profile_picture',
    VoidCallback? onCameraPressed,
    VoidCallback? onGalleryPressed,
  }) async {
    final ImagePicker imagePicker = ImagePicker();
    return await Get.bottomSheet(
      Container(
        height: Get.height * .3,
        width: Get.width,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Text(
                title.tr,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      title: "camera".tr,
                      icons: Icons.camera,
                      onTap: () async {
                        if (onCameraPressed == null) {
                          final image = await imagePicker.pickImage(
                              source: ImageSource.camera);
                          Get.back(result: image);
                        } else {
                          onCameraPressed.call();
                          Get.back();
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomCard(
                      title: "gallery".tr,
                      icons: Icons.image,
                      onTap: () async {
                        if (onGalleryPressed == null) {
                          final image = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          Get.back(result: image);
                        } else {
                          onGalleryPressed.call();
                          Get.back();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Get.theme.colorScheme.background,
    );
  }

  static Future<void> waveAction(
      {final IconData? icons,
      final VoidCallback? onDeleteTap,
      final VoidCallback? onDownlodTap,
      final String? title,
      final String? fileurl,
      final Color? color}) async {
    return await Get.bottomSheet(
      DownloadAndDelete(
        icons: icons!,
        title: title!,
        color: color,
        fileurl: fileurl!,
        onDeleteTap: onDeleteTap,
        onDownlodTap: onDownlodTap,
      ),
      backgroundColor: Get.theme.colorScheme.background,
    );
  }
}

class DownloadAndDelete extends StatelessWidget {
  final IconData icons;
  final String title;
  final String fileurl;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onDownlodTap;
  const DownloadAndDelete({
    super.key,
    required this.icons,
    required this.title,
    this.color,
    this.onTap,
    required this.fileurl,
    this.onDeleteTap,
    this.onDownlodTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: Get.width * .15,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          SizedBox(height: Get.height * .02),
          ListTile(
            style: ListTileStyle.drawer,
            contentPadding: const EdgeInsets.all(6.0),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: color ?? Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Icon(
                icons,
                color: Colors.black,
              ),
            ),
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodyText2,
            ),
          ),
          const Divider(thickness: 1.5),
          SizedBox(height: Get.height * .02),
          ListTile(
            style: ListTileStyle.drawer,
            tileColor: Colors.green,
            contentPadding: const EdgeInsets.all(6.0),
            leading: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Icon(
                Icons.download,
                color: Colors.green,
              ),
            ),
            title: Text(
              'download'.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodyText2,
            ),
            onTap: onDownlodTap,
          ),
          SizedBox(height: Get.height * .02),
          ListTile(
            title: Text(
              'delete'.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodyText2,
            ),
            style: ListTileStyle.drawer,
            tileColor: Get.theme.colorScheme.error,
            contentPadding: const EdgeInsets.all(6.0),
            leading: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Icon(
                  Icons.delete,
                  color: Get.theme.colorScheme.error,
                )),
            onTap: () => CustomDialog.showYesNoDialog(
              title: 'delete_Video'.tr,
              content: 'are_you_sure_you_want_to_delete_the_video'.tr,
              onYesPressed: onDeleteTap,
            ),
          ),
        ],
      ),
    );
  }
}
