import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/values/consts.dart';

class WaveOne extends StatelessWidget {
  const WaveOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.0,
      child: SvgPicture.asset(
        AppSvg.wave1,
        colorFilter: const ColorFilter.mode(
          Colors.grey,
          BlendMode.srcATop,
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}

class WaveTwo extends StatelessWidget {
  const WaveTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.0,
      child: SvgPicture.asset(
        AppSvg.wave2,
        colorFilter: const ColorFilter.mode(
          Colors.grey,
          BlendMode.srcATop,
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}

class WaveThree extends StatelessWidget {
  const WaveThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.0,
      child: SvgPicture.asset(
        AppSvg.wave3,
        colorFilter: const ColorFilter.mode(
          Colors.grey,
          BlendMode.srcATop,
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}