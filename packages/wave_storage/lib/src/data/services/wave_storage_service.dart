// ignore_for_file: unnecessary_getters_setters

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:wave_core/wave_core.dart';

import '../../core/utils/errors/storage_exception.dart';
import '../../core/utils/helpers/custom_logs.dart';
import '../apis/storage_api.dart';
import '../model/ai_media.dart';
import '../model/media.dart';

class WaveStorage {
  static final WaveStorage instance = WaveStorage(storageAPI: StorageAPI());

  final StorageAPI storageAPI;

  WaveStorage({
    required this.storageAPI,
  });

  /// Checks if the server is running.
  ///
  /// Returns a [Future<Map<String, dynamic>>] containing the server response.
  Future<Map<String, dynamic>> checkServer() async {
    try {
      final Response response = await storageAPI.checkServer();

      switch (response.statusCode) {
        case 200:
          return response.data as Map<String, dynamic>;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveStorageException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to check server.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Ai upload
  ///
  /// Returns a [Future<List<Media>>] containing the server response.
  Future<List<AIMedia>> aiUpload({
    required String uid,
    required List<String> paths,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final Response response = await storageAPI.aiUpload(
        uid: uid,
        paths: paths,
        onSendProgress: onSendProgress,
      );

      switch (response.statusCode) {
        case 200:
          final mediaList = <AIMedia>[];
          final files = response.data['files'] as List<dynamic>;
          for (final item in files) {
            if (item['status'] == Status.success.name) {
              final file = (item as Map<String, dynamic>)['media'];
              mediaList.add(AIMedia.fromMap(file));
            }
          }
          return mediaList;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveStorageException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to ai upload.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Uploads a file to the server.
  ///
  /// Returns a [Future<List<Media>>] containing the server response.
  Future<List<Media>> upload({
    required List<String> paths,
    String? filesDir,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final Response response = await storageAPI.upload(
        paths: paths,
        filesDir: filesDir,
        onSendProgress: onSendProgress,
      );

      switch (response.statusCode) {
        case 200:
          final mediaList = <Media>[];
          final files = response.data['files'] as List<dynamic>;
          for (final file in files) {
            final fileMap = file;
            if (fileMap['status'] == Status.success.name) {
              mediaList.add(Media.fromMap(fileMap));
            }
          }
          return mediaList;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveStorageException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to ai upload.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Folders
  ///
  /// Returns a [Future<Map<String, dynamic>>] containing the server response.
  Future<Map<String, dynamic>> folders({String? folder}) async {
    try {
      final Response response = await storageAPI.folders(folder: folder);

      switch (response.statusCode) {
        case 200:
          if (response.data is Map<String, dynamic>) {
            return response.data;
          } else {
            logError(
                'If you are seeing this, becuase the url is not correct. or the folder is not found.');
            throw WaveStorageException(
              message: 'Failed to get folders.',
              code: 'folder_not_found',
              statusCode: 404,
            );
          }

        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveStorageException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to ai upload.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Get the url for the file path.
  ///
  /// Returns a [Future<String>] containing the server response.
  Future<String> getUrlFormPath({required String path}) async {
    try {
      return '${storageAPI.baseUrl}/${storageAPI.baseRoute}/folders/$path';
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Download Media
  ///
  /// Returns a [Future<void>]
  Future<void> downloadMedia({
    required String uid,
    required String urlPath,
    required String fileName,
  }) async {
    try {
      final Response response = await storageAPI.downloadMedia(
        uid: uid,
        urlPath: urlPath,
        fileName: fileName,
      );

      switch (response.statusCode) {
        case 200:
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveStorageException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to ai upload.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }
}
