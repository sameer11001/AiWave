import 'package:flutter/material.dart';

import 'wave_widgets.dart';

enum WaveBackgroundType { one, two , three}

class WaveBackground extends StatelessWidget {
  final Widget child;
  final WaveBackgroundType waveType;
  const WaveBackground({
    super.key,
    required this.child,
    this.waveType = WaveBackgroundType.one,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: waveType == WaveBackgroundType.one
              ? const WaveOne()
              : waveType == WaveBackgroundType.two
                  ? const WaveTwo()
                  : const WaveThree(),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ),
      ],
    );
  }
}
