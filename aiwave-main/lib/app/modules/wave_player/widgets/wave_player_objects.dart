import 'package:aiwave/app/core/utils/extensions/research_wave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/wave_player_controller.dart';

class WavePlayerObjects extends GetView<WavePlayerController> {
  const WavePlayerObjects({super.key});

  @override
  Widget build(BuildContext context) {
    final objects = controller.objectsInfo?.objects ?? [];

    return Material(
      child: ListView.builder(
        itemCount: objects.length,
        itemBuilder: (context, index) {
          final object = objects[index];

          return ListTile(
            leading: CircleAvatar(
              child: Text('${object.id}'),
            ),
            title: Text(object.objectName.capitalize ?? object.objectName),
            subtitle: Text(
              '${object.firstDetectTime.fixedString()} -> ${object.lastDetectTime.fixedString()}',
            ),
          );
        },
      ),
    );
  }
}
