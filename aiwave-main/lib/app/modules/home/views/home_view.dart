import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';

import '../../../global_widgets/custom_drawer.dart';
import '../../../global_widgets/upload_stack.dart';
import '../widgets/home_appbar.dart';
import '../widgets/home_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return UploadStack(
      child: ThemeSwitchingArea(
        child: Builder(builder: (context) {
          return const Scaffold(
            extendBodyBehindAppBar: true,
            drawer: CustomDrawer(),
            appBar: HomeAppBar(),
            body: HomeBody(),
          );
        }),
      ),
    );
  }
}
