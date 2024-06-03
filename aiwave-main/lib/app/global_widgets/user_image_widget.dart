import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../core/values/consts.dart';
import '../data/model/user_model.dart';
import 'image_viewer_list.dart';

class UserImageWidget extends StatelessWidget {
  final double? size;
  final void Function()? onTap;
  final String? imageUrl;
  const UserImageWidget({
    super.key,
    this.size = 40,
    this.onTap,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            ImageViewerList.show(
              imageUrls: [
                imageUrl ??
                    UserAccount.currentUser?.imageUrl ??
                    AppConstant.defultUserImage,
              ],
            );
          },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(350),
        child: UserAccount.currentUser?.imageUrl != null
            ? Obx(() => imageBody())
            : imageBody(),
      ),
    );
  }

  CachedNetworkImage imageBody() {
    return CachedNetworkImage(
      imageUrl: imageUrl ??
          UserAccount.currentUser?.imageUrl ??
          AppConstant.defultUserImage,
      height: size,
      width: size,
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) {
        if (!UserAccount.currentUser!.isAdmin) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(350),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        }
        return RippleAnimation(
          color: Colors.green,
          delay: const Duration(milliseconds: 300),
          repeat: true,
          duration: const Duration(milliseconds: 6 * 300),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Image(
                image: imageProvider,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
        );
      },
      progressIndicatorBuilder: (context, url, download) {
        if (download.progress != null) {
          final percent = download.progress! * 100;
          return Center(
            child: FittedBox(
              child: Text('${percent.toStringAsFixed(1)}%'),
            ),
          );
        }
        return const Center(child: FittedBox(child: Text('Loading')));
      },
      errorWidget: (context, url, error) => Icon(
        Icons.account_circle,
        size: size,
      ),
    );
  }
}
