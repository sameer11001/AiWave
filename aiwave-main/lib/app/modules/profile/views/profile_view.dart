import 'package:aiwave/app/global_widgets/wave_background.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../widgets/profile_body.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('profile'.tr),
        centerTitle: true,
      ),
      body: const WaveBackground(
        waveType: WaveBackgroundType.three,
        child: ProfileBody(),
      ),
    );
  }
}
