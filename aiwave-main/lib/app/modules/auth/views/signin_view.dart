import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../global_widgets/loading_widget.dart';
import '../../../global_widgets/wave_background.dart';
import '../controllers/signin_controller.dart';
import '../widgets/signin_body.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});
  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      isLoading: controller.isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: const WaveBackground(child: SigninBody()),
      ),
    );
  }
}
