import 'package:aiwave/app/global_widgets/wave_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:markdown_widget/markdown_widget.dart';
import 'package:wave_ai/wave_ai.dart';

class MarkdownView extends StatelessWidget {
  final ResearchDocs doc;
  const MarkdownView({super.key, required this.doc});

  static Future<void> show({required ResearchDocs doc}) async {
    await Get.to(
      () => MarkdownView(
        doc: doc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          doc.fileName.split('.').first,
        ),
      ),
      body: WaveBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          child: MarkdownWidget(
            data: doc.content ?? '',
          ),
        ),
      ),
    );
  }
}
