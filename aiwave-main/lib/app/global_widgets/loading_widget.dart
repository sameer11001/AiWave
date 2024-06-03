import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../core/values/consts.dart';

class LoadingWidget extends StatelessWidget {
  final RxBool isLoading;
  final Widget child;
  const LoadingWidget(
      {super.key, required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PopScope(
        canPop: !isLoading.value,
        child: Stack(
          children: [
            child,
            Obx(() {
              if (isLoading.value) {
                return SizedBox(
                  height: Get.height,
                  width: Get.width,
                  // color: Colors.black.withOpacity(.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Center(
                          child: Container(
                            height: Get.height * .25,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              // color: context.theme.colorScheme.background
                              //     .withOpacity(0.9),
                            ),
                            child: Lottie.asset(
                              AppConstant.loading,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            })
          ],
        ),
      ),
    );
  }
}

class BlurOverlay extends StatelessWidget {
  final RxBool isLoading;
  final Widget child;
  const BlurOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PopScope(
        canPop: !isLoading.value,
        child: Stack(
          children: [
            child,
            Obx(() {
              if (isLoading.value) {
                return Container(
                  height: Get.height,
                  width: Get.width,
                  color: Colors.black.withOpacity(.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          color: Colors.black.withOpacity(.3),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            })
          ],
        ),
      ),
    );
  }
}
