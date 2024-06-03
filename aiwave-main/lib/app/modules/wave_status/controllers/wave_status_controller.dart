import 'package:aiwave/app/core/utils/helpers/custom_logs.dart';
import 'package:aiwave/app/core/utils/helpers/custom_snack_bar.dart';
import 'package:get/get.dart';
import 'package:wave_ai/wave_ai.dart';
import 'package:wave_storage/wave_storage.dart';

import '../../../data/model/user_model.dart';

class WaveStatusController extends GetxController {
  late final Rx<BaseStatus> _status;

  // Stream getter for status changes
  BaseStatus get status => _status.value;
  set status(BaseStatus value) => _status.value = value;

  @override
  void onInit() {
    super.onInit();

    // Get the status from the arguments
    _status = (Get.arguments as BaseStatus).obs;

    // Bind the status
    _bindStatus();
  }

  void _bindStatus() {
    final userUid = UserAccount.currentUser!.uid;
    status.onChanged(userUid: userUid).listen(
          onData,
          onDone: onDone,
          onError: onError,
        );

    // status.onChanged(userUid: userUid).listen((event) {
    //   logInfo('Status changed: ${event.stateMessage}');
    // });
  }

  void onData(BaseStatus status) {
    logDebug('Status changed: ${status.uid}');
    // Check if the status is completed
    if (status.state == StatusState.completed) {
      // Update the status
      this.status = status;
      // Call the onDone method
      onDone();
    } else {
      final List<String> updatedKeys = [];
      // Check if the progress is not the same
      if (this.status.progress != status.progress) {
        // Find the difference between the progress
        final difference = status.progress
            .where((element) => !this.status.progress.contains(element))
            .toList();
        // Check if the difference is not empty
        if (difference.isNotEmpty) {
          // Add the progress keys to the list
          for (var element in difference) {
            updatedKeys.add('progress-${element.step}');
          }
        }
      }
      // Check if the state message is not the same
      if (this.status.stateMessage != status.stateMessage ||
          this.status.state != status.state) {
        updatedKeys.add('status-message');
      }
      // Update the status
      this.status = status;
      // Update the status keys
      if (updatedKeys.isNotEmpty) {
        // Update the UI
        update(updatedKeys);
      }
    }
  }

  Future<void> onDone() async {
    try {
      final wordWave = WaveAI.instance.wordWave;
      final userUid = UserAccount.currentUser!.uid;
      final mediaUid = status.mediaUid;
      final aiMedia = await wordWave.getMediaByUid(
        userUid: userUid,
        mediaUid: mediaUid,
      );
      Get.back<AIMedia>(result: aiMedia);
    } catch (e) {
      logError(e.toString());
    }
  }

  void onError(dynamic e) {
    CustomSnackBar.error(message: e.toString());
  }

  Future<void> onBack() async {
    Get.back();
  }
}
