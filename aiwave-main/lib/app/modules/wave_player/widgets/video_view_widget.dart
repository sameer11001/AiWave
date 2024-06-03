import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../core/theme/text_theme.dart';
import '../controllers/wave_player_controller.dart';

import '../../../core/utils/extensions/word_wave.dart';

bool check = true;

class VideoViewWidget extends GetView<WavePlayerController> {
  const VideoViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final chewieController = controller.chewieController;
    return Container(
      height: Get.height * .3,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.3),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Container(
                //   color: Colors.red,
                // ),
                GestureDetector(
                  onTap: () {
                    if (controller.hide) {
                      controller.hide = false;
                    }
                  },
                  onDoubleTap: () => controller.togglePlay(),
                  child: Chewie(
                    controller: chewieController,
                  ),
                ),

                const Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: PlayerAppBar(),
                ),
                const Positioned.fill(
                  child: PlayButtonWidget(),
                ),

                if (controller.subtitleList != null)
                  // Postion subtitle
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: Obx(
                      () {
                        final subTitles = controller.subtitleList
                            ?.toWordWaveSubTitle()
                            .subtitle;
                        final subtitle = subTitles?[controller.currentIndex];
                        return SubTitleWiget(subtitle: subtitle!);
                      },
                    ),
                  ),
              ],
            ),
          ),
          VideoProgressIndicator(
            controller.chewieController.videoPlayerController,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: Theme.of(context).colorScheme.primary,
              bufferedColor:
                  Theme.of(context).colorScheme.primary.withOpacity(.3),
              backgroundColor: Colors.grey.withOpacity(.3),
            ),
          ),
          const PlayerBottomBar()
        ],
      ),
    );
  }
}

class PlayerAppBar extends GetView<WavePlayerController> {
  const PlayerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: Get.width * .06,
          width: Get.width * .15,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 8.0,
                width: 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Text(
                controller.chewieController.isLive ? "LIVE" : "VOD",
                style: AppStyle.bodyText3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        if (controller.subtitleList != null)
          // Show subtitle
          Obx(
            () {
              if (controller.hide) {
                return const SizedBox.shrink();
              }
              return IconButton(
                onPressed: () => controller.toggleSubtitle(),
                padding: EdgeInsets.zero,
                icon: Icon(
                  controller.showSubtitle
                      ? Icons.closed_caption
                      : Icons.closed_caption_off,
                ),
              );
            },
          ),
      ],
    );
  }
}

class PlayButtonWidget extends GetView<WavePlayerController> {
  const PlayButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.hide) {
          return const SizedBox.shrink();
        }

        return Center(
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                Colors.grey.withOpacity(.7),
              ),
            ),
            icon: Icon(
              controller.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () => controller.togglePlay(),
          ),
        );
      },
    );
  }
}

class SubTitleWiget extends GetView<WavePlayerController> {
  final Subtitle subtitle;
  const SubTitleWiget({super.key, required this.subtitle});
   
  @override
  Widget build(BuildContext context) {
    
    return Obx(
      () {
        if (!controller.showSubtitle) {
          
          return const SizedBox.shrink();
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          width: 100,
          color: Colors.black.withOpacity(.8),
          child: Text(
            subtitle.text,
            textAlign: TextAlign.center,
            style: AppStyle.bodyText3.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class PlayerBottomBar extends GetView<WavePlayerController> {
  const PlayerBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Obx(
                      () => Text(
                        controller.position.fixedString(),
                        style: AppStyle.bodyText3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextSpan(
                    text: " / ",
                    style: AppStyle.bodyText3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: controller.duration.fixedString(),
                    style: AppStyle.bodyText3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                  Obx(
                    () {
                      IconData volumeIcon = controller.isMute
                          ? Icons.volume_off
                          : Icons.volume_up_outlined;

                      return IconButton(
                        icon: Icon(volumeIcon),
                        onPressed: () => controller.toggleMute(),
                      );
                    },
                  ),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(
                //     Icons.settings,
                //   ),
                // ),
                IconButton(
                  icon: const Icon(
                    Icons.fullscreen,
                  ),
                  onPressed: () => controller.toggleFullScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
