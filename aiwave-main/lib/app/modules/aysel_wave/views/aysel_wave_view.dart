import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../widgets/aysel_drawer.dart';
import '../controllers/aysel_wave_controller.dart';
import '../widgets/aysel_wave_appbar.dart';
import '../widgets/aysel_wave_body.dart';

class AyselWaveView extends GetView<AyselWaveController> {
  const AyselWaveView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      endDrawer: ReserachDrawer(),
      appBar: AyselWaveAppBar(),
      body: AyselWaveBody(),
    );
  }
}
