import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/values/consts.dart';

class LoadingLogo extends StatelessWidget {
  final DownloadProgress? download;
  final EdgeInsetsGeometry? margin;
  const LoadingLogo({super.key, this.download, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppConstant.logo,
              height: constraints.maxHeight * .5,
              width: constraints.maxWidth * .5,
              frameBuilder: (BuildContext context, Widget child, int? frame,
                  bool wasSynchronouslyLoaded) {
                return AnimatedOpacity(
                  opacity: .2,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: child,
                );
              },
            ),
            if (download != null)
              download!.progress != null
                  ? FittedBox(
                      child: Text(
                          '${(download!.progress! * 100).toStringAsFixed(1)}%'),
                    )
                  : const FittedBox(
                      child: Text('Loading ..'),
                    )
          ],
        );
      }),
    );
  }
}

class ErrorNetworkWidget extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  const ErrorNetworkWidget({super.key, this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(8.0),
      width: Get.width * .8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.grey.shade400,
        image: const DecorationImage(
          image: AssetImage(AppConstant.logo),
        ),
      ),
      child: child,
    );
  }
}
