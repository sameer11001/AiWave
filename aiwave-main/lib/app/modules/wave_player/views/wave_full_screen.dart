import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

class WaveFullScreenView extends StatefulWidget {
  final ChewieController chewieController;
  const WaveFullScreenView({super.key, required this.chewieController});

  @override
  State<WaveFullScreenView> createState() => _WaveFullScreenViewState();
}

class _WaveFullScreenViewState extends State<WaveFullScreenView> {
  @override
  void initState() {
    super.initState();

    // // Rotate the screen to landscape mode:
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

    // // Hide the status bar
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    super.dispose();

    // // Rotate the screen to portrait mode:
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

    // // Show the status bar
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: SystemUiOverlay.values,
    // );

    // Dispose the chewie controller
    widget.chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chewie(
        controller: widget.chewieController,
      ),
    );
  }
}
