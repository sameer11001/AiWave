import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../controllers/wave_player_controller.dart';
import '../../../core/utils/extensions/word_wave.dart';

class WavePlayerChat extends GetView<WavePlayerController> {
  const WavePlayerChat({super.key});

  @override
  Widget build(BuildContext context) {
    final subTitles = controller.subtitleList?.toWordWaveSubTitle();

    return Material(
      child: ScrollablePositionedList.builder(
        itemCount: subTitles?.subtitle.length ?? 0,
        itemScrollController: controller.itemScrollController,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final subtitle = subTitles?.subtitle[index];
          return GetBuilder<WavePlayerController>(
            id: 'subtitle-$index',
            builder: (_) {
              final isCurrent = controller.currentIndex == index;
              return ListTile(
                tileColor: isCurrent
                    ? Theme.of(context).colorScheme.primary.withOpacity(.3)
                    : null,
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(subtitle?.text ?? ''),
                subtitle: Text(
                    '${subtitle?.start.fixedString()} -> ${subtitle?.end.fixedString()}'),
              );
            },
          );
        },
      ),
    );
  }
}
