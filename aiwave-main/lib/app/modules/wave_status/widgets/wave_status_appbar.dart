import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controllers/wave_status_controller.dart';

class WaveStatusAppBar extends GetView<WaveStatusController>
    implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  const WaveStatusAppBar({super.key, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
