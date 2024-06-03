import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrWidget extends StatelessWidget {
  final Color? dividerColors;
  final Color? textColors;
  const OrWidget({super.key, this.dividerColors, this.textColors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Divider(
          color: dividerColors,
        )),
        Text(
          "   ${'or'.tr}    ",
          style: TextStyle(
            color: textColors,
          ),
        ),
        Expanded(
            child: Divider(
          color: dividerColors,
        )),
      ],
    );
  }
}
