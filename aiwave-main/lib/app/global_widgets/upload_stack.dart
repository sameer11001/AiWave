import 'dart:io';

import 'package:aiwave/app/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_storage/wave_storage.dart';

import '../core/utils/helpers/custom_logs.dart';

class UploadStack extends StatelessWidget {
  final Widget child;
  const UploadStack({super.key, required this.child});

  void onDismissed(UploadStackFile file, {bool showSnackbar = true}) {
    try {
      final uuid = file.uuid;
      logDebug('Upload [$uuid] dismissed', name: 'UploadStack');
      UploadStackController.instance.hide(file.uuid);

      // Check if the snackbar is already shown
      if (Get.isSnackbarOpen == false && showSnackbar) {
        Get.snackbar(
          'Upload dismissed',
          'The upload of ${file.fileName} has been dismissed.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      logError(e.toString(), name: "UploadStack");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: kToolbarHeight,
            horizontal: 20,
          ),
          child: Obx(() {
            final items = UploadStackController.instance.items;
            return ListView.builder(
              itemCount: items.keys.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final item = items.values.elementAt(index);
                return Dismissible(
                  key: Key(item.uuid),
                  direction: DismissDirection.startToEnd,
                  // onDismissed: (direction) {
                  //   onDismissed(item);
                  // },
                  child: UploadStackCard(
                    file: item,
                    // onClosedTap: () => onDismissed(item),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class UploadStackCard extends StatelessWidget {
  final UploadStackFile file;
  final VoidCallback? onClosedTap;
  const UploadStackCard({super.key, required this.file, this.onClosedTap});

  @override
  Widget build(BuildContext context) {
    file.onCompleted(() => UploadStackController.instance.hide(file.uuid));
    return Card(
      child: ListTile(
        leading: const Icon(Icons.upload_file),
        title: Text(
          '${file.fileName} [${file.fileExtension.toUpperCase()}]',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: GetBuilder<UploadStackFile>(
          init: file,
          id: 'file-${file.uuid}',
          builder: (_) {
            return Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    color: file.isCompleted ? Colors.green : null,
                    value: file.progress == 0.0 ? null : file.progress,
                  ),
                ),
                const SizedBox(width: 10),
                file.isCompleted
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      )
                    : Row(
                        children: [
                          Text(
                            '${(file.progress * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ],
            );
          },
        ),
        trailing: onClosedTap != null
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClosedTap,
              )
            : null,
        onTap: file.isCompleted ? onClosedTap : null,
      ),
    );
  }
}

class UploadStackController extends GetxController {
  static UploadStackController get instance =>
      Get.put<UploadStackController>(UploadStackController());

  final RxMap<String, UploadStackFile> _items = <String, UploadStackFile>{
    // '1': UploadFile(
    //   uuid: '1',
    //   filePath: 'path/to/file',
    //   fileName: 'file_name',
    //   fileExtension: 'jpg',
    //   fileSize: 1000,
    // ),
  }.obs;

  final Map<String, UploadStackFile> _hiddenItems = {};

  Map<String, UploadStackFile> get items => _items;

  Future<AIMedia?> uploadFileInBackground(String filePath) async {
    // Get the current user's uid
    final uid = UserAccount.currentUser!.uid;

    final data = {
      'uid': uid,
      'filePath': filePath,
    };
    // Use compute to run the upload operation in a separate isolate (thread)
    // await compute(_uploadFile, data);

    // Run the upload operation in the same isolate (thread)
    List<AIMedia>? mediaList = await _uploadFile(data);
    if (mediaList != null && mediaList.isNotEmpty) {
      // Show the snackbar
      Get.snackbar(
        'File has been uploaded',
        'The file has been uploaded successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return mediaList.first;
    } else {
      return null;
    }
  }

  void hide(String uuid) {
    // Add the item to the hidden items
    _hiddenItems[uuid] = _items[uuid]!;
    // Remove the item from the items
    _items.remove(uuid);
  }

  void show(String uuid) {
    // Add the item to the items
    _items[uuid] = _hiddenItems[uuid]!;
    // Remove the item from the hidden items
    _hiddenItems.remove(uuid);
  }

  bool isExists(String uuid) {
    // Check if the item exists in the items
    return _items.containsKey(uuid);
  }

  // This is the actual upload operation that runs in a separate thread
  static Future<List<AIMedia>?> _uploadFile(Map<String, dynamic> data) async {
    try {
      // Get the data
      final uid = data['uid'];
      final filePath = data['filePath'];

      // Get the storage instance
      final storage = WaveStorage.instance;

      // Create an upload file object
      UploadStackFile uploadFile = UploadStackFile.fromFilePath(filePath);

      // Add the upload to the list
      UploadStackController.instance._items[uploadFile.uuid] = uploadFile;

      // Upload the file
      return await storage.aiUpload(
        uid: uid,
        paths: [filePath],
        onSendProgress: (count, total) {
          // Update the upload progress
          final progress = count / total;
          uploadFile.progress = progress;
        },
      );
    } catch (e) {
      logError(e.toString(), name: "UploadController");
      return null;
    }
  }
}

class UploadStackFile extends GetxController {
  final String uuid;
  final String filePath;
  final String fileName;
  final String fileExtension;
  final int fileSize;
  double _progress;

  UploadStackFile({
    required this.uuid,
    required this.filePath,
    required this.fileName,
    required this.fileExtension,
    required this.fileSize,
  }) : _progress = 0.0;

  double get progress => _progress;
  set progress(double value) {
    _progress = value;

    // Check if the upload is completed
    if (isCompleted) {
      onCompleted(null);
    } else {
      update(['file-$uuid']);
    }
  }

  bool get isCompleted => _progress >= 0.9999999999999999;

  VoidCallback? _defultCallback;

  void onCompleted(VoidCallback? callback) {
    if (callback != null) {
      _defultCallback = callback;
    }

    if (isCompleted) {
      _defultCallback?.call();
    }
  }

  factory UploadStackFile.fromFilePath(String filePath) {
    final fileName = filePath.split('/').last;
    final fileSize = File(filePath).lengthSync();
    final fileExtension = fileName.split('.').last;

    return UploadStackFile(
      uuid: UniqueKey().toString(),
      filePath: filePath,
      fileName: fileName,
      fileExtension: fileExtension,
      fileSize: fileSize,
    );
  }
}
