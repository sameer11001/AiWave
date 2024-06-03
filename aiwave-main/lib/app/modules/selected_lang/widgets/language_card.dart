import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageCard extends StatelessWidget {
  final String title;
  final bool checked;
  final ValueChanged<bool>? onChange;
  final IconData? icons;
  const LanguageCard({
    super.key,
    required this.title,
    this.checked = false,
    this.onChange,
    this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (onChange != null) {
            onChange!(!checked);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    checked ? Icons.check_circle : null,
                    color: Get.theme.colorScheme.primary,
                  ),
                ],
              ),
              Expanded(
                child: FittedBox(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Icon(
                        icons ?? Icons.g_translate,
                        size: 60,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        title.tr,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
