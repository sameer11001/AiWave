import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../global_widgets/loading_widget.dart';
import '../../../global_widgets/wave_background.dart';
import '../controllers/signup_controller.dart';
import '../widgets/signup_body.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      isLoading: controller.isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: const WaveBackground(child: SignupBody()),
      ),
    );
  }
}
