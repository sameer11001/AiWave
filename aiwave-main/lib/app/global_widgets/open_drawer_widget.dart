import 'package:flutter/material.dart';

import '../core/values/consts.dart';

class OpenDrawerWidget extends StatelessWidget {
  const OpenDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Tooltip(
          message: 'Open Drawer',
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Ink.image(
              image: const AssetImage(AppConstant.logo),
              width: 25,
              height: 25,
            ),
          ),
        ),
      );
    });
  }
}
