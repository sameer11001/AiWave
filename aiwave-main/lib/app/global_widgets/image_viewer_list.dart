import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/text_theme.dart';

class ImageViewerList extends StatelessWidget {
  final List<dynamic> imageUrls;
  final int initialImageIndex;
  final String? title;
  final bool enableDownload;
  const ImageViewerList({
    super.key,
    required this.imageUrls,
    this.initialImageIndex = 0,
    this.title,
    this.enableDownload = true,
  });

  static show({
    required List<dynamic> imageUrls,
    int initialImage = 0,
    String? title,
  }) {
    Get.to(
      () => ImageViewerList(
        imageUrls: imageUrls,
        initialImageIndex: initialImage,
        title: title,
      ),
    );
  }

  Future<void> download() async {}

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: initialImageIndex);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title ?? "Image",
        ),
        actions: [
          if (enableDownload)
            IconButton(
              onPressed: download,
              tooltip: 'download'.tr,
              icon: const Icon(
                Icons.download,
              ),
            )
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: PageView.builder(
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              String imageUrl = imageUrls[index];
              return Hero(
                tag: imageUrl,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  progressIndicatorBuilder: (_, url, download) {
                    if (download.progress != null) {
                      final percent = download.progress! * 100;
                      return Center(
                        child: FittedBox(
                          child: Text(
                            '${percent.toStringAsFixed(1)}%',
                            style: AppStyle.headLine1,
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: FittedBox(
                        child: Text(
                          'Loading...',
                          style: AppStyle.headLine1,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
