import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_storage/wave_storage.dart';

import '../../../data/model/user_model.dart';

class HomeController extends GetxController {
  late final PageController pageController;
  late final TextEditingController textEditingController;
  RxBool isAdminActionOpen = false.obs;
  RxInt currentIndex = 1.obs;

  late final AIMedia aiMedia;

  final RxString statusUid = ''.obs;

  @override
  void onInit() {
    super.onInit();

    pageController = PageController(initialPage: currentIndex.value);
    textEditingController = TextEditingController();
  }


  List<String> get urls {
    final mediaList = UserAccount.mediaList;
    final List<String> urlList = [];
    for (var i = 0; i < mediaList.length; i++) {
      final media = mediaList[i];
      urlList.add(media.fileUrl);
    }
    return urlList;
  }

  List<BaseProcess> get videosMedia {
    final mediaList = UserAccount.mediaList;
    final List<BaseProcess> processList = [];
    for (var i = 0; i < mediaList.length; i++) {
      final media = mediaList[i];
      processList.addAll(media.aiProcesses);
    }
    return processList;
  }

   List<dynamic> get items {
    List<dynamic> combinedList = [];
    
    combinedList.addAll(videosMedia);
    combinedList.addAll(UserAccount.archiveList);

    return combinedList;
  }

  void changePage(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
