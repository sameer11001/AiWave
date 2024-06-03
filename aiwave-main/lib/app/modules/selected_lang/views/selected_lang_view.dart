import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/selected_lang_controller.dart';
import '../widgets/selected_lang_body.dart';

class SelectedLangView extends GetView<SelectedLangController> {
  const SelectedLangView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SelectedLangBody(),
    );
  }
}
