// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';

import '../core/utils/helpers/custom_bottom_sheet.dart';

class UploadImageWidget extends StatefulWidget {
  List<Asset>? assetImage;

  List<String>? networkUrl;
  List<XFile>? cameraImage;
  final ValueChanged<List<String>>? networkUrlChange;
  final ValueChanged<List<Asset>>? assetImageChange;
  final ValueChanged<List<dynamic>>? allImagesChange;
  final double? height;
  final bool enableCamera;
  final int maxImage;
  final bool editable;
  UploadImageWidget({
    super.key,
    this.assetImage,
    this.networkUrl,
    this.cameraImage,
    this.networkUrlChange,
    this.assetImageChange,
    this.height,
    this.enableCamera = false,
    this.allImagesChange,
    this.maxImage = 10,
    this.editable = true,
  });

  @override
  State<UploadImageWidget> createState() => UploadImageWidgetState();
}

class UploadImageWidgetState extends State<UploadImageWidget> {
  List<dynamic> allImages = [];
  bool flag = false;

  void onTap() {
    if (flag) {
      pikeFromView();
    } else {
      chooseImage();
    }
  }

  Future<void> chooseImage() async {
    final res = await CustomBottomSheet.imagePiker(
      title: '',
      onGalleryPressed: pikeFromView,
    );
    if (res != null) {
      if (widget.cameraImage == null) {
        widget.cameraImage = [res];
      } else {
        widget.cameraImage!.add(res);
      }
      flag = true;
      allImageCallBack();
      setState(() {});
    }
  }

  void pikeFromView() async {
    try {
      final resultImages = await MultipleImagesPicker.pickImages(
        maxImages:
            (widget.maxImage - allImages.length).clamp(0, widget.maxImage),
        enableCamera: widget.enableCamera && flag,
        selectedAssets: widget.assetImage ?? [],
      );
      widget.assetImage = resultImages;
      allImageCallBack();
      setState(() {});
      if (widget.assetImageChange != null) {
        widget.assetImageChange!(widget.assetImage ?? []);
      }
    } catch (e) {
      e.printError();
    }
  }

  void allImageCallBack() {
    allImages = [];
    for (var item in widget.assetImage ?? []) {
      allImages.add(item);
    }
    for (var item in widget.networkUrl ?? []) {
      allImages.add(item);
    }

    for (var item in widget.cameraImage ?? []) {
      allImages.add(item);
    }

    widget.allImagesChange?.call(allImages);
  }

  @override
  void initState() {
    super.initState();
    allImageCallBack();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: allImages.isEmpty
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.add),
                  Text('select_images'.tr),
                ],
              ),
            )
          : GridView.count(
              crossAxisCount: 3,
              children: List.generate(
                allImages.length + 1,
                (index) {
                  if (index == allImages.length) {
                    return (allImages.length < widget.maxImage) &&
                            widget.editable
                        ? Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.background,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              onTap: onTap,
                              borderRadius: BorderRadius.circular(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add),
                                  Text("pick_images".tr)
                                ],
                              ),
                            ),
                          )
                        : const SizedBox();
                  } else {
                    final item = allImages[index];
                    if (item is Asset) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DeleteImageAtIndex(
                          editable: widget.editable,
                          onTap: () {
                            setState(() => allImages.removeAt(index));

                            widget.assetImage =
                                allImages.whereType<Asset>().toList();

                            if (widget.assetImageChange != null) {
                              widget.assetImageChange!(widget.assetImage ?? []);
                            }
                          },
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: AssetThumb(
                              asset: item,
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ),
                      );
                    } else if (item is String) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DeleteImageAtIndex(
                          editable: widget.editable,
                          onTap: () {
                            setState(() => allImages.removeAt(index));
                            widget.networkUrl =
                                allImages.whereType<String>().toList();

                            if (widget.networkUrlChange != null) {
                              widget.networkUrlChange!(widget.networkUrl ?? []);
                            }
                          },
                          child: Card(
                            child: CachedNetworkImage(
                              imageUrl: item,
                              width: 150,
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    } else if (item is XFile) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DeleteImageAtIndex(
                          editable: widget.editable,
                          onTap: () {
                            setState(() => allImages.removeAt(index));
                            widget.networkUrl =
                                allImages.whereType<String>().toList();

                            if (widget.networkUrlChange != null) {
                              widget.networkUrlChange!(widget.networkUrl ?? []);
                            }
                          },
                          child: Card(
                            child: Image.file(
                              File(item.path),
                              width: 150,
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }
                },
              ),
            ),
    );
  }
}

class DeleteImageAtIndex extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool editable;
  const DeleteImageAtIndex({
    super.key,
    required this.child,
    required this.onTap,
    this.editable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (editable)
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 15,
                width: 15,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 12,
                ),
              ),
            ),
          )
      ],
    );
  }
}
