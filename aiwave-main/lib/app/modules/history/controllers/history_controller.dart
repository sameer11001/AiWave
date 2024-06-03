import 'package:aiwave/app/core/utils/helpers/custom_dialog.dart';
import 'package:aiwave/app/core/utils/helpers/custom_snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_ai/wave_ai.dart';
import 'package:wave_core/wave_core.dart';
import 'package:wave_storage/wave_storage.dart';

import '../../../core/utils/helpers/custom_logs.dart';
import '../../../data/model/user_model.dart';
import '../../../global_widgets/upload_stack.dart';
import '../../wave_player/views/wave_player_view.dart';
import '../../wave_status/views/wave_status_view.dart';

class HistoryController extends GetxController {
  static HistoryController get to => Get.find();
  late Map<String, dynamic> args;
  late final AIModelType modelType;

  late final PageController pageController;
  final RxInt _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int value) => _selectedIndex.value = value;

  final RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get the data from the arguments passed to the route
    args = Get.arguments as Map<String, dynamic>;

    // Get the model type from the arguments
    modelType = args['modelType'] as AIModelType;

    // Initialize the page controller
    pageController = PageController(initialPage: selectedIndex);
  }

  void onViewSelected(int index) {
    selectedIndex = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: modelType.allowedFileExtensions,
        allowMultiple: false,
        dialogTitle: 'Select media',
      );

      final path = result?.files.single.path;

      if (path != null) {
        final aiMedia =
            await UploadStackController.instance.uploadFileInBackground(path);
        if (aiMedia != null) {
          UserAccount.mediaList.add(aiMedia);
        }
      }
    } catch (e) {
      logError(e.toString(), name: "PickFilesWidget");
    }
  }

  Future<void> _wordWaveProcess({
    required AIMedia media,
    Language language = Language.auto,
    WordWaveTask task = WordWaveTask.defaultTask,
  }) async {
    // Set the processing state to true
    isProcessing.value = true;

    try {
      final userUid = UserAccount.currentUser!.uid;
      final wordWave = WaveAI.instance.wordWave;
      final mediaUid = media.uid;

      try {
        final status = await wordWave.run(
          userUid: userUid,
          mediaUid: mediaUid,
          language: language,
          task: task,
        );

        final media = await WaveStatusView.show(status: status);
        // Check if the media is not null
        if (media != null) {
          int existingMediaIndex = UserAccount.mediaList
              .indexWhere((existingMedia) => existingMedia == media);

          if (existingMediaIndex != -1) {
            UserAccount.mediaList.removeAt(existingMediaIndex);
          }

          UserAccount.mediaList.add(media);
        }
      } on WaveAIException catch (e) {
        final errorMessages = e.message;

        CustomSnackBar.error(message: errorMessages);
      }
    } catch (e) {
      logError(e.toString(), name: 'VideoCard');
    }

    // Set the processing state to false
    isProcessing.value = false;
  }

  Future<void> _visionWaveProcess({
    required AIMedia media,
    List<VisionObject>? classes,
    VisionWaveTask task = VisionWaveTask.detect,
  }) async {
    // Set the processing state to true
    isProcessing.value = true;

    try {
      final userUid = UserAccount.currentUser!.uid;
      final visionWave = WaveAI.instance.visionWave;
      final mediaUid = media.uid;

      try {
        final status = await visionWave.run(
          userUid: userUid,
          mediaUid: mediaUid,
          filters: classes,
          task: task,
        );

        final media = await WaveStatusView.show(status: status);
        // Check if the media is not null
        if (media != null) {
          int existingMediaIndex = UserAccount.mediaList
              .indexWhere((existingMedia) => existingMedia == media);

          if (existingMediaIndex != -1) {
            UserAccount.mediaList.removeAt(existingMediaIndex);
          }

          UserAccount.mediaList.add(media);
        }
      } on WaveAIException catch (e) {
        final errorMessages = e.message;

        CustomSnackBar.error(message: errorMessages);
      }
    } catch (e) {
      logError(e.toString(), name: 'VideoCard');
    }

    // Set the processing state to false
    isProcessing.value = false;
  }

  Future<void> _onWaveProcessTap(AIMedia media) async {
    List<Map<String, dynamic>>? subtitleList;
    BaseProcess? process = media.getProcessByModelType(modelType);
    final data = process?.data;
    if (data is WordWaveDetails) {
      final wordWave = WaveAI.instance.wordWave;

      final hasNewProcess = data
              .getDataByType(
                type: StatusDetailsDataType.srt,
              )!
              .content !=
          null;

      if (!hasNewProcess) {
        final newProcess = await wordWave.getProcessContent(
          userUid: UserAccount.currentUser!.uid,
          mediaUid: media.uid,
          processUid: process!.uid!,
        );

        // update the old process with the new process data
        process.data = newProcess.data;
      }

      final content = (process!.data as WordWaveDetails)
          .getDataByType(
            type: StatusDetailsDataType.srt,
          )!
          .content as List<dynamic>;

      // Convert to list of Map<String, dynamic>
      subtitleList = content.map((e) => e as Map<String, dynamic>).toList();

      await WavePlayerView.show(
        title: media.fileName,
        videoUrl: media.fileUrl,
        subtitleList: subtitleList,
      );
    }
  }

  Future<void> _onVisionProcessTap(AIMedia media) async {
    BaseProcess? process = media.getProcessByModelType(modelType);
    final data = process?.data;
    if (data is VisionWaveDetails) {
      final filePath = data.outputFile!.path!;
      final objectsInfo = data.objectsInfo;
      final storage = WaveStorage.instance;
      final url = await storage.getUrlFormPath(path: filePath);

      await WavePlayerView.show(
        title: media.fileName,
        videoUrl: url,
        objectsInfo:objectsInfo,
      );
    }
  }

  Future<void> onProcessTap(AIMedia media) async {
    // Check if the model type is word wave
    if (modelType == AIModelType.wordWave) {
      await _onWaveProcessTap(media);
    } else {
      await _onVisionProcessTap(media);
    }
  }

  Future<void> onMediaTap(AIMedia media) async {
    // Check if the model type is word wave
    if (modelType == AIModelType.wordWave) {
      final res = await CustomDialog.showWordWaveDialog(media: media);
      if (res != null) {
        final language = res['language'] as Language;
        final task = res['task'] as WordWaveTask;
        _wordWaveProcess(media: media, language: language, task: task);
      }
    } else {
      final res = await CustomDialog.showVisionWaveDialog(media: media);
      if (res != null) {
        final classes = res['classes'] as List<VisionObject>;
        final task = res['task'] as VisionWaveTask;
        _visionWaveProcess(media: media, classes: classes, task: task);
      }
    }
  }

  void onPageChanged(int index) => selectedIndex = index;
}
