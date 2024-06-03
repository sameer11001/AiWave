import '../core/utils/extensions/word_wave.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoManager extends StatefulWidget {
  final String videoUrl;
  final List<Map<String, dynamic>>? subTitle;
  const VideoManager({
    super.key,
    required this.videoUrl,
    this.subTitle,
  });

  @override
  State<VideoManager> createState() => _VideoManagerState();
}

class _VideoManagerState extends State<VideoManager> {
  bool isLoading = true;
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  Future<void> initVideo() async {
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    await videoPlayerController!.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      subtitle: widget.subTitle?.toWordWaveSubTitle(),
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Video Manager'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Chewie(
                controller: chewieController!,
              ),
      ),
    );
  }
}
