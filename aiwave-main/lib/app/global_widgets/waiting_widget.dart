import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/values/consts.dart';

class WaitingWidget extends StatelessWidget {
  const WaitingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        AppConstant.loading,
        fit: BoxFit.cover,
      ),
    );
  }
}
