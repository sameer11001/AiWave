
import 'package:flutter/material.dart';

import '../core/theme/text_theme.dart';

class StarsWidget extends StatelessWidget {
  final double starsNumber;

  const StarsWidget({super.key, required this.starsNumber});

  @override
  Widget build(BuildContext context) {
    int fullStars = starsNumber.floor();
    bool hasHalfStar = (starsNumber - fullStars) >= 0.5;

    List<Widget> starWidgets = [];
    for (int i = 0; i < fullStars; i++) {
      starWidgets.add(const Icon(Icons.star, color: Colors.yellow));
    }

    if (hasHalfStar) {
      starWidgets.add(const Icon(Icons.star_half, color: Colors.yellow));
    }

    starWidgets.add(Text(
      '  $starsNumber',
      style: AppStyle.headLine5.copyWith(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
      ),
    ));

    return Row(
      children: starWidgets,
    );
  }
}
