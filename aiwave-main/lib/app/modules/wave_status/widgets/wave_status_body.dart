import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/wave_widgets.dart';
import '../controllers/wave_status_controller.dart';
import 'wave_status_ball.dart';
import 'wave_status_bottom.dart';
import 'wave_status_header.dart';
import 'wave_status_message.dart';

class WaveStatusBody extends GetView<WaveStatusController> {
  const WaveStatusBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: WaveThree(),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: kToolbarHeight),
                WaveStatusHeader(),
                Spacer(flex: 1),
                WaveStatusBallWidget(),
                Spacer(flex: 1),
                WaveStatusMessageWidget(),
                Spacer(flex: 3),
                WaveStatusBottomWidget(),
                Spacer(flex: 1)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
