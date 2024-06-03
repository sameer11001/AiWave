import 'package:aiwave/app/modules/wave_player/views/wave_full_screen.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';
import 'package:wave_ai/wave_ai.dart';
import '../../../core/utils/extensions/word_wave.dart';

class WavePlayerController extends GetxController {
  static WavePlayerController get to => Get.find();
  late Map<String, dynamic> args;
  late final ItemScrollController itemScrollController;

  late String? title;
  late String videoUrl;
  late List<Map<String, dynamic>>? subtitleList;
  late ObjectsInfo? objectsInfo;
  late VideoPlayerController? videoPlayerController;
  late ChewieController chewieController;

  final Rx<int> _currentIndex = 0.obs;
  final Rx<Duration> _position = Duration.zero.obs;
  late final Duration duration;
  final Rx<bool> _isPlaying = false.obs;
  final Rx<bool> _hide = false.obs;
  final RxBool _isMute = false.obs;
  final RxBool _showSubtitle = false.obs;
  final RxBool _isVisible = true.obs;

  int get currentIndex => _currentIndex.value;
  set currentIndex(int value) => _currentIndex.value = value;

  Duration get position => _position.value;
  set position(Duration value) => _position.value = value;

  bool get isPlaying => _isPlaying.value;
  set isPlaying(bool value) => _isPlaying.value = value;

  bool get hide => _hide.value;
  set hide(bool value) => _hide.value = value;

  bool get isMute => _isMute.value;
  set isMute(bool value) => _isMute.value = value;

  bool get showSubtitle => _showSubtitle.value;
  set showSubtitle(bool value) => _showSubtitle.value = value;

  bool get isVisible => _isVisible.value;
  set isVisible(bool value) => _isVisible.value = value;

  @override
  void onInit() {
    super.onInit();

    // Initialize the scroll controller
    itemScrollController = ItemScrollController();

    // Get the data from the arguments passed to the route
    args = Get.arguments as Map<String, dynamic>;

    // Get the title from the arguments
    title = args['title'] as String?;
    // Get the video url from the arguments
    videoUrl = args['videoUrl'] as String;
    // Get the subtitle list from the arguments
    subtitleList = args['subtitleList'] as List<Map<String, dynamic>>?;
    // Get the objects info from the arguments
    objectsInfo = args['objectsInfo'] as ObjectsInfo?;
    // Get the video player controller from the arguments
    videoPlayerController =
        args['videoPlayerController'] as VideoPlayerController?;

    // Initialize the video player
    initVideoPlayer();
  }

  void initVideoPlayer() {
    try {
      // Initialize video player controller

      if (videoPlayerController != null &&
          videoPlayerController!.value.isInitialized) {
        videoPlayerController = videoPlayerController!;
      } else {
        videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
        );
      }

      // Add listener to the video player controller to track the subtitle
      addPlayerListener();
    } catch (e) {
      videoPlayerController = null;
      return initVideoPlayer();
    }

    // Change the show subtitle to based on the subtitle list is not null
    showSubtitle = subtitleList != null;

    // Get the video duration
    duration = videoPlayerController!.value.duration;

    // Initialize Chewie controller
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      // aspectRatio: 16 / 9, // Adjust as needed
      autoPlay: true,
      looping: false,
      subtitle: subtitleList?.toWordWaveSubTitle(),
      showControls: false,
    );

    // Change the video player mute to false
    videoPlayerController!.setVolume(1.0);
  }

  void addPlayerListener() {
    // Add listener to the video player controller to track the subtitle
    videoPlayerController?.addListener(trackDuration);
  }

  void removePlayerListener() {
    // Remove listener to the video player controller to track the subtitle
    videoPlayerController?.removeListener(trackDuration);
  }

  int _lastScrollIndex = -1;
  void trackDuration() {
    // Check if the video is playing
    isPlaying = chewieController.videoPlayerController.value.isPlaying;
    // Check if the video is muted
    isMute = chewieController.videoPlayerController.value.volume == 0;

    // Get the current position of the video
    position = chewieController.videoPlayerController.value.position;
    // Get the current index of the subtitle
    chewieController.subtitle?.subtitle.asMap().forEach((index, subtitle) {
      // Check if the current position is greater than the subtitle start
      if (position > subtitle!.start) {
        // Check if the current position is less than the subtitle end
        if (position < subtitle.end && index != _lastScrollIndex) {
          // Update the subtitle index
          update(['subtitle-$index', 'subtitle-$currentIndex']);
          currentIndex = index;

          // Scroll to the current subtitle.m
          scrollHandler(index);

          // Update the last scroll index
          _lastScrollIndex = index;
        }
      }
    });

    // Check if the controls are hidden
    checkControlsHide();
  }

  void togglePlay() {
    // Check if the video is playing
    if (isPlaying) {
      // Pause the video
      chewieController.pause();
    } else {
      // Play the video
      chewieController.play();
    }
  }

  void toggleMute() {
    // Check if the video is muted
    if (isMute) {
      // Unmute the video
      chewieController.setVolume(1);
    } else {
      // Mute the video
      chewieController.setVolume(0);
    }
  }

  Future<void> toggleFullScreen() async {
    // Remove listener to the video player controller to track the subtitle
    removePlayerListener();
    // Enter full screen
    await Get.to(
      () => WaveFullScreenView(
        chewieController: ChewieController(
          videoPlayerController: videoPlayerController!,
          fullScreenByDefault: true,
          subtitle: subtitleList?.toWordWaveSubTitle(),
        ),
      ),
    );
    // Add listener to the video player controller to track the subtitle
    addPlayerListener();
  }

  void toggleSubtitle() => showSubtitle = !showSubtitle;

  void toggleSubtitleChat() => isVisible = !isVisible;

  // Create a function to check if the video is playing for 3 second
  bool isRunning = false;
  void checkControlsHide() async {
    // Check if the video is playing
    if (isPlaying && !isRunning) {
      // Set the isRunning to true
      isRunning = true;
      // Wait for 1 second
      await Future.delayed(const Duration(seconds: 3));
      // Check if the video is still playing
      if (isPlaying) {
        // Hide the controls
        hide = true;
      }
      // Set the isRunning to false
      isRunning = false;
    }
  }

  void scrollHandler(int index) {
    try {
      if (!isVisible) return;
      // itemScrollController.scrollTo(
      //   index: index,
      //   duration: const Duration(milliseconds: 500),
      //   curve: Curves.easeInOutCubic,
      // );
      itemScrollController.jumpTo(
        index: index,
      );
    } catch (err) {
      printError(info: err.toString());
    }
  }

  @override
  void onClose() {
    super.onClose();

    // Dispose the video player controller
    videoPlayerController?.dispose();
    // Dispose the chewie controller
    chewieController.dispose();
  }
}
