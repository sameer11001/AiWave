import 'dart:developer';

import 'package:aiwave/app/core/utils/extensions/research_wave.dart';
import 'package:aiwave/app/core/utils/helpers/custom_logs.dart';
import 'package:aiwave/app/core/utils/helpers/custom_snack_bar.dart';
import 'package:aiwave/app/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';
import 'package:wave_ai/wave_ai.dart';

import '../models/message_model.dart';

class AyselWaveController extends GetxController {
  late final PageController pageController;

  late ScrollController scrollController;
  late TextEditingController textController;

  final RxBool _isListening = false.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _available = false.obs;
  final RxBool _isAlpha = false.obs;
  final Rx<ResearchSource> _researchSource = ResearchSource.arxiv.obs;

  final List<Message> talksMessages = <Message>[].obs;
  final List<Message> insightfulMessages = <Message>[].obs;

  bool get available => _available.value;
  set available(bool value) => _available.value = value;

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
  final RxInt _selectedIndex = 0.obs;

  bool get isListening => _isListening.value;
  set isListening(bool value) => _isListening.value = value;

  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int value) => _selectedIndex.value = value;

  bool get isAlpha => _isAlpha.value;
  set isAlpha(bool value) => _isAlpha.value = value;

  //for speech to text
  var speechText = ''.obs;
  stt.SpeechToText speechToText = stt.SpeechToText();

  @override
  void onInit() async {
    super.onInit();

    // Initialize the text controller
    textController = TextEditingController();

    // Initialize the scroll controller
    scrollController = ScrollController();

    // Initialize the page controller
    pageController = PageController(initialPage: selectedIndex);

    // Initialize the speech to text
    _available(await speechToText.initialize());
  }

  void onViewSelected(int index) => selectedIndex = index;

  RxBool showMicIcon = true.obs;
  void onChanged(String value) {
    // Show the mic icon if the text field is empty
    showMicIcon(value.isEmpty);
  }

  Future<void> sendMessage() async {
    // Close the keyboard
    FocusScope.of(Get.overlayContext!).requestFocus(FocusNode());
    // Get the text from the text field
    final text = textController.text;
    if (text.isEmpty) return;
    // Start loading
    _isLoading(true);

    // Clear the text field
    textController.clear();
    // Show the mic icon after clearing the text field
    showMicIcon(true);
    // Add the message to the list
    final userMessage = Message(
      uid: const Uuid().v4(),
      id: 1,
      text: text,
    );
    final botMessage = Message(
      uid: const Uuid().v4(),
      id: 0,
    );
    // Add the message to the list
    if (isAlpha) {
      insightfulMessages.add(userMessage);
      insightfulMessages.add(botMessage);
    } else {
      talksMessages.add(userMessage);
      talksMessages.add(botMessage);
    }

    update(['messages']);
    // Scroll to the end of the list
    scrollToEnd();

    // Generate the response
    final res = await generateResponse(text);
    // Update the message
    if (isAlpha) {
      botMessage.researchDocs = res;
    } else {
      botMessage.text = res.content;
    }
    update(['message-${botMessage.uid}']);
    // Scroll to the end of the list
    scrollToEnd();
    // Stop loading
    _isLoading(false);
  }

  Future<ResearchDocs> generateResponse(String prompt) async {
    try {
      final userUid = UserAccount.currentUser!.uid;
      final researcherWave = WaveAI.instance.researcherWave;
      WaveAI.instance.researcherWave.getdocs(userUid: userUid);

      final ResearchOutput output = await researcherWave.run(
        userUid: userUid,
        prompt: prompt,
        alpha: isAlpha,
      );
      // COnvert the output to research docs
      final doc = output.toResearchDocs();
      // Check if is alpha
      if (isAlpha) {
        // Add the message to the user messages list
        UserAccount.archiveList.add(doc);
      }

      return doc;
    } on WaveAIException catch (e) {
      final errorMessages = e.message;
      CustomSnackBar.error(message: errorMessages);
    } catch (e) {
      logError(e.toString(), name: 'chatBot');
    }
    return ResearchDocs(
      fileName: 'untitled',
      fileUrl: '',
      content: 'sorry there is no answer',
    );
  }

  Future<void> openMic() async {
    FocusScope.of(Get.overlayContext!).requestFocus(FocusNode());
    if (!isListening) {
      if (available) {
        isListening = true;
        speechToText.listen(
          partialResults: false,
          onResult: (val) {
            speechText.value = val.recognizedWords;
            log("Listening_on: $isListening");
            log("Recognized Words: ${speechText.value}");
          },
          listenFor: const Duration(seconds: 10),
        );
      }
    } else {
      isListening = false;
      speechToText.stop();

      log("Listening_off: $isListening");
      log(speechText.value);

      textController.text = speechText.value.toString();
      showMicIcon(false);
      speechText.value = '';
    }
  }

  void toggleResearchSource() {
    // Toggle the research source
    _researchSource(
      _researchSource.value == ResearchSource.arxiv
          ? ResearchSource.wikipedia
          : ResearchSource.arxiv,
    );
    // Show snackbar
    final foregroundColor = Get.isDarkMode ? Colors.black : Colors.white;
    final backgroundColor = Get.isDarkMode ? Colors.white : Colors.black;
    ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: foregroundColor,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                '${'research_source_changed'.tr} ${'to'.tr} `${_researchSource.value.name.tr}`',
                style: TextStyle(
                  color: foregroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        duration: 1.seconds,
      ),
    );
  }

  bool get isArchive => _researchSource.value == ResearchSource.arxiv;

  void scrollToEnd() {
    try {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: 1.seconds,
        curve: Curves.easeInOut,
      );
    } catch (_) {}
  }

  @override
  void onClose() {
    super.onClose();

    // Dispose the text controller
    textController.dispose();

    // Dispose the scroll controller
    scrollController.dispose();

    // Dispose the page controller
    pageController.dispose();
  }
}
