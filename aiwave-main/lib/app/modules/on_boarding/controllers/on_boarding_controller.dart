import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/values/consts.dart';
import '../widgets/on_boarding_page.dart';

class OnBoardingController extends GetxController {
  late final LiquidController liquidController;

  RxInt currentPage = 0.obs;
  final RxBool _isLastPage = false.obs;

  bool get isListPage => _isLastPage.value;

  @override
  void onInit() {
    super.onInit();
    liquidController = LiquidController();

    _isLastPage(pages.length == 1);
  }

  final pages = [
    OnBoardingPage(
      assestImage: AppConstant.onBoardingPage1,
      title: 'on_boarding_page_1_title',
      description: 'on_boarding_page_1_description',
      data: Get.isDarkMode ? AppTheme.dark : AppTheme.light,
    ),
    OnBoardingPage(
      assestImage: AppConstant.onBoardingPage2,
      title: 'on_boarding_page_2_title',
      description: 'on_boarding_page_2_description',
      data: Get.isDarkMode ? AppTheme.light : AppTheme.dark,
    ),
    OnBoardingPage(
      assestImage: AppConstant.onBoardingPage3,
      title: 'on_boarding_page_3_title',
      description: 'on_boarding_page_3_description',
      data: Get.isDarkMode ? AppTheme.dark : AppTheme.light,
    ),
  ];

  onPageChangeCallback(int activePageIndex) {
    currentPage.value = activePageIndex;
    _isLastPage(activePageIndex == pages.length - 1);
  }

  skip() => liquidController.jumpToPage(page: pages.length - 1);

  animateToNextSlide() {
    int nextPage = liquidController.currentPage + 1;
    liquidController.animateToPage(page: nextPage, duration: 300);
  }
}
