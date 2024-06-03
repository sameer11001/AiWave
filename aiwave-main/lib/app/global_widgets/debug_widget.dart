import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/model/user_model.dart';

class DebugWidget extends StatelessWidget {
  final Widget child;
  const DebugWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode || UserAccount.currentUser!.isAdmin) {
      return child;
    }
    return const SizedBox();
  }
}
