import 'package:aiwave/app/core/utils/helpers/custom_dialog.dart';
import 'package:aiwave/app/core/utils/helpers/custom_logs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/text_theme.dart';
import 'custom_button.dart';
import 'or_widget.dart';

enum WaveFileType {
  any(allowedExtensions: []),
  wordWave(allowedExtensions: ["mp4", "mkv", "avi", "mp3", "wav"]),
  visionWave(allowedExtensions: ["mp4", "mkv", "avi", "mp3", "wav"]);

  final List<String> allowedExtensions;
  const WaveFileType({
    required this.allowedExtensions,
  });
}

class PickFilesWidget extends StatefulWidget {
  final Future<void> Function(String?)? onFileSelected;
  final WaveFileType fileType;
  final bool allowMultiple;
  final String? helpText;
  const PickFilesWidget({
    super.key,
    this.onFileSelected,
    this.fileType = WaveFileType.any,
    this.allowMultiple = false,
    this.helpText,
  });

  @override
  State<PickFilesWidget> createState() => _PickFilesWidgetState();
}

class _PickFilesWidgetState extends State<PickFilesWidget> {
  String? hasFile;
  bool isLoading = false;
  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: widget.fileType == WaveFileType.any
            ? FileType.any
            : FileType.custom,
        allowedExtensions: widget.fileType == WaveFileType.any
            ? null
            : widget.fileType.allowedExtensions,
        allowMultiple: widget.allowMultiple,
      );
      setState(() => isLoading = true);
      final path = result?.files.single.path;
      setState(() {
        hasFile = path;
      });
      await widget.onFileSelected?.call(path);
    } catch (e) {
      logError(e.toString(), name: "PickFilesWidget");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.grey.withOpacity(.7),
          width: 2.0,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: Get.height * 0.25,
            width: Get.width,
            child: InkWell(
              onTap: isLoading || hasFile != null ? null : _pickFiles,
              borderRadius: BorderRadius.circular(8.0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey.withOpacity(.7),
                        width: 2.0,
                      ),
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                hasFile != null
                                    ? Icons.check_circle_outline
                                    : Icons.cloud_upload,
                                size: Get.height * .13,
                                color: hasFile != null
                                    ? Colors.green
                                    : Get.theme.colorScheme.onBackground
                                        .withOpacity(.7),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                hasFile != null ? 'done'.tr : "browse_files".tr,
                                textAlign: TextAlign.center,
                                style: AppStyle.bodyText1.copyWith(
                                  color: Get.theme.colorScheme.onBackground
                                      .withOpacity(.7),
                                ),
                              ),
                            ],
                          ),
                  ),
                  if (widget.helpText != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: IconButton(
                          icon: const Icon(Icons.help_outline),
                          tooltip: "help".tr,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              const CircleBorder(),
                            ),
                          ),
                          onPressed: () async {
                            await CustomDialog.showDoneDialog(
                              title: "help".tr,
                              body: SelectableText(
                                widget.helpText!,
                                style: AppStyle.headLine4,
                                textAlign: TextAlign.start,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          OrWidget(
            textColors: hasFile != null ? Colors.transparent : null,
            dividerColors: Colors.grey.withOpacity(.7),
          ),
          const SizedBox(height: 12.0),
          isLoading
              ? const LinearProgressIndicator()
              : hasFile != null
                  ? const SizedBox()
                  : CustomFutureButton(
                      label: Text(
                        "browse_files".tr,
                        style: AppStyle.bodyText2.copyWith(
                          color: Get.theme.colorScheme.onPrimary,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      onPressed: _pickFiles,
                    )
        ],
      ),
    );
  }
}
