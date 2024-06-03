import 'package:aiwave/app/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AyselWaveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AyselWaveAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'aysel_wave'.tr,
        style: AppStyle.headLine2,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Builder(
            builder: (context) {
              return IconButton(
                color: Theme.of(context).colorScheme.onBackground,
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            },
          ),
        ),
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
