import 'dart:developer';

import 'package:wave_storage/wave_storage.dart';

class StorageDatabase {
  /// Instance of the [WaveStorage] class.
  static final WaveStorage _storage = WaveStorage.instance;

  /// Uploads a user image to Wave Storage.
  ///
  /// [imagePath] - Local path of the image to be uploaded.
  /// [uid] - Unique identifier for the user.
  ///
  /// Returns a [Future<String>] representing the download URL of the uploaded image.
  static Future<String?> uploadUserImage({
    required String imagePath,
    required String uid,
  }) async {
    log('''
    -------------------------
    | path: $imagePath,     |
    | uuid: $uid,           |
    -------------------------
    ''');

    try {
      // Create a directory for the user
      final filesDir = 'users/$uid';
      // Upload the image to the storage
      final uploadTasks = await _storage.upload(
        paths: [imagePath],
        filesDir: filesDir,
      );
      log('url: ${uploadTasks.first.fileUrl}');
      return uploadTasks.first.fileUrl;
    } catch (e) {
      log('Error uploading user image: $e,\n $imagePath');
      return null;
    }
  }
}
