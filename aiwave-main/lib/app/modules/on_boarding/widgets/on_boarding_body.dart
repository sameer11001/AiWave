import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theme/text_theme.dart';
import '../../../data/database/local_database.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../routes/app_pages.dart';
import '../controllers/on_boarding_controller.dart';

class OnBoardingBody extends GetView<OnBoardingController> {
  const OnBoardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        LiquidSwipe(
          pages: controller.pages,
          liquidController: controller.liquidController,
          onPageChangeCallback: controller.onPageChangeCallback,
          enableSideReveal: false,
        ),
        Positioned(
          bottom: 60.0,
          left: 16,
          right: 16,
          child: GetX<OnBoardingController>(
            builder: (_) {
              final isLastPage = controller.isListPage;
              return CustomButton(
                onPressed: () {
                  if (isLastPage) {
                    LocalDatabase.isFirstTime = false;
                    Get.offAllNamed(Routes.SIGNIN);
                  } else {
                    controller.animateToNextSlide();
                  }
                },
                label: isLastPage
                    ? 'on_boarding_page_get_started'.tr
                    : 'on_boarding_page_next'.tr,
              );
            },
          ),
        ),
        Positioned(
          top: 50,
          right: 20,
          child: GetX<OnBoardingController>(
            builder: (_) {
              final isLastPage = controller.isListPage;
              return isLastPage
                  ? const SizedBox()
                  : TextButton(
                      onPressed: () {
                        controller.currentPage(controller.pages.length - 1);
                        controller.skip();
                      },
                      child: Text(
                        "on_boarding_page_skip".tr,
                        style: AppStyle.bodyText3.copyWith(
                          color: Get.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
            },
          ),
        ),
        Obx(
          () => Positioned(
            bottom: 10,
            child: AnimatedSmoothIndicator(
              count: controller.pages.length,
              activeIndex: controller.currentPage.value,
              effect: WormEffect(
                activeDotColor: Get.theme.colorScheme.primary,
                dotColor: Get.theme.colorScheme.onSurfaceVariant,
                dotHeight: 5,
              ),
            ),
          ),
        )
      ],
    );
  }
}
