import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wave_storage/wave_storage.dart';

class VideoCard extends StatefulWidget {
  final AIMedia media;
  final bool showControls;
  final Future<void> Function()? onPressed;
  const VideoCard({
    super.key,
    required this.media,
    this.showControls = true,
    this.onPressed,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late final VideoPlayerController _videoPlayerController;
  bool isPlaying = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final videoUrl = widget.media.fileUrl;
    // Initialize video player controller
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
    )
      ..setVolume(0.0)
      ..initialize().then(
        (value) {
          // Update the UI to display the video
          setState(() {});
        },
      );

    // Add listener to the video player controller
    _videoPlayerController.addListener(() {
      final isPlaying = _videoPlayerController.value.isPlaying;
      if (this.isPlaying != isPlaying) {
        setState(() {
          this.isPlaying = isPlaying;
        });
      }
    });
  }

  // Video Player Controlls
  void play() => _videoPlayerController.play();

  void pause() => _videoPlayerController.pause();

  void togglePlay() {
    isPlaying ? pause() : play();
  }

  @override
  void dispose() {
    // Dispose of the video and chewie controllers
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Theme.of(context).cardColor,
      disabledColor: Theme.of(context).cardColor,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: widget.onPressed == null || isLoading
          ? null
          : () async {
              setState(() => isLoading = true);
              try {
                await widget.onPressed?.call().whenComplete(() => null);
              } catch (_) {}
              setState(() => isLoading = false);
            },
      child: Column(
        children: [
          Expanded(
            child: _videoPlayerController.value.isInitialized
                ? Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                      if (widget.showControls && !isLoading)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).cardColor,
                              ),
                            ),
                            onPressed: togglePlay,
                          ),
                        ),
                      if (isLoading)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const SizedBox(
                              height: 12.0,
                              width: 12.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).cardColor,
                              ),
                            ),
                            onPressed: togglePlay,
                          ),
                        )
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.media.fileName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
