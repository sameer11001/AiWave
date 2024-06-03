// ignore_for_file: unnecessary_getters_setters

import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:wave_storage/wave_storage.dart';

import '../../../wave_ai.dart';
import '../../core/utils/helpers/custom_logs.dart';
import '../apis/word_wave_api.dart';

class WordWave {
  static final WordWave instance = WordWave(wordWaveAPI: WordWaveAPI());

  final WordWaveAPI wordWaveAPI;

  WordWave({
    required this.wordWaveAPI,
  });

  /// Checks if the server is running.
  ///
  /// Returns a [Future<Map<String, dynamic>>] containing the server response.
  Future<Map<String, dynamic>> checkServer() async {
    try {
      final Response response = await wordWaveAPI.checkServer();

      switch (response.statusCode) {
        case 200:
          return response.data as Map<String, dynamic>;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAIException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to check server.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Runs the word wave algorithm.
  ///
  /// Returns a [Future<Status>] containing the server response.
  Future<WordWaveStatus> run({
    required String userUid,
    required String mediaUid,
    Language language = Language.auto,
    WordWaveTask task = WordWaveTask.defaultTask,
  }) async {
    try {
      final Response response = await wordWaveAPI.run(
        userUid: userUid,
        mediaUid: mediaUid,
        language: language,
        task: task,
      );

      switch (response.statusCode) {
        case 200:
          final data = response.data['status'] as Map<String, dynamic>;
          WordWaveStatus status = WordWaveStatus.fromMap(data);
          return status;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAIException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to run word wave.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Gets the status of the word wave algorithm.
  ///
  /// Returns a [Future<Status>] containing the server response.
  Future<WordWaveStatus> getStatus(
      {required String userUid, required String statusUid}) async {
    try {
      final Response response = await wordWaveAPI.getStatus(
        userUid: userUid,
        statusUid: statusUid,
      );

      switch (response.statusCode) {
        case 200:
          final data = response.data['status'] as Map<String, dynamic>;
          WordWaveStatus status = WordWaveStatus.fromMap(data);
          return status;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAIException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to get status.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Runs the word wave algorithm and sets up status stream.
  Future<void> runWithStatusStream({
    required String userUid,
    required String statusUid,
    required StreamController<WordWaveStatus> statusController,
  }) async {
    await _runStatusCheck({
      'action': 'startStatusCheck',
      'userUid': userUid,
      'statusUid': statusUid,
      'statusController': statusController,
    });
  }

  static Future<void> _runStatusCheck(Map<String, dynamic> message) async {
    final WordWave wordWave = WordWave.instance;
    if (message['action'] == 'startStatusCheck') {
      final String userUid = message['userUid'];
      final String statusUid = message['statusUid'];
      final StreamController<WordWaveStatus> statusController =
          message['statusController'];
      WordWaveStatus? prevStatus;
      bool isFirst = true;
      while (true) {
        try {
          final Response response = await wordWave.wordWaveAPI.getStatus(
            userUid: userUid,
            statusUid: statusUid,
          );

          switch (response.statusCode) {
            case 200:
              final data = response.data['status'] as Map<String, dynamic>;
              WordWaveStatus status = WordWaveStatus.fromMap(data);
              // Check if this is the first status
              if (isFirst) {
                // Add the status to the _prevStatus
                prevStatus = status;
                isFirst = false;
              }
              // Check if the status has changed
              if (prevStatus != null && prevStatus != status) {
                // Add the status to the stream
                statusController.add(status);
              }
              // check if is status is completed
              if (status.state == StatusState.completed) {
                // Close the stream controller
                statusController.close();
                // Exit the isolate
                return;
              }
              break;
            default:
              if (response.data is Map<String, dynamic>) {
                throw WaveAIException.fromRespone(response);
              }
              throw Exception(
                  '[${response.statusCode}]. Failed to get status.');
          }
          // Sleep for some time before checking again
          await Future.delayed(const Duration(seconds: 10));
        } catch (e) {
          logError(e.toString());
          // Close the stream with exception
          statusController.addError(e);
          // Rethrow the exception to propagate it further if needed.
          rethrow;
        }
      }
    }
  }

  // ignore: unused_element
  static void _runStatusCheckIsolate(SendPort sendPort) {
    final WordWave wordWave = WordWave.instance;

    // Set up a receive port to listen for messages
    ReceivePort receivePort = ReceivePort();

    // Send the send port to the caller
    sendPort.send(receivePort.sendPort);

    // Listen for messages
    receivePort.listen((message) async {
      if (message['action'] == 'startStatusCheck') {
        String userUid = message['userUid'];
        String statusUid = message['statusUid'];
        StreamController<BaseStatus> statusController =
            message['statusController'];

        BaseStatus? prevStatus;
        bool isFirst = true;
        while (true) {
          try {
            final Response response = await wordWave.wordWaveAPI.getStatus(
              userUid: userUid,
              statusUid: statusUid,
            );

            switch (response.statusCode) {
              case 200:
                final data = response.data['status'] as Map<String, dynamic>;
                WordWaveStatus status = WordWaveStatus.fromMap(data);
                // Check if this is the first status
                if (isFirst) {
                  // Add the status to the _prevStatus
                  prevStatus = status;
                  isFirst = false;
                }
                // Check if the status has changed
                if (prevStatus != null && prevStatus != status) {
                  // Add the status to the stream
                  statusController.add(status);
                }
                // check if is status is completed
                if (status.state == StatusState.completed) {
                  // Close the stream controller
                  statusController.close();
                  // Exit the isolate
                  return;
                }
              default:
                if (response.data is Map<String, dynamic>) {
                  throw WaveAIException.fromRespone(response);
                }
                throw Exception(
                    '[${response.statusCode}].Failed to get status.');
            }

            // Sleep for some time before checking again
            await Future.delayed(const Duration(seconds: 3));
          } catch (e) {
            logError(e.toString());
            // Close the with exception
            statusController.addError(e);
            // Close the thread
            receivePort.close();
            // Rethrow the exception to propagate it further if needed.
            rethrow;
          }
        }
      }
    });
  }

  /// Gets the process of the word wave algorithm.
  ///
  /// Return List<String> but for prevent any error i put dynamic
  Future<List<AIMedia>> getAllMedia({
    required userUid,
  }) async {
    try {
      final Response response = await wordWaveAPI.getAllMedia(userUid: userUid);
      switch (response.statusCode) {
        case 200:
          final data = response.data['media_list'] as List<dynamic>;

          //
          List<AIMedia> mediaList = data
              .map((e) => AIMedia.fromMap(e as Map<String, dynamic>))
              .toList();

          return mediaList;

        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAIException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to get status.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Gets the process by Uid of the word wave algorithm.
  ///
  /// Returns a [Future<AiMedia>] containing the server response.
  Future<AIMedia> getMediaByUid({
    required String userUid,
    required String mediaUid,
  }) async {
    try {
      final Response response = await wordWaveAPI.getMediaByUid(
        userUid: userUid,
        mediaUid: mediaUid,
      );

      switch (response.statusCode) {
        case 200:
          final data = response.data['media'] as Map<String, dynamic>;

          AIMedia aiMedia = AIMedia.fromMap(data);
          return aiMedia;

        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAIException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to get status.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Get the process content by Uid of the word wave algorithm.
  ///
  /// Returns a [Future<WordWaveProcess>] containing the server response.
  Future<WordWaveProcess> getProcessContent({
    required String userUid,
    required String mediaUid,
    required String processUid,
  }) async {
    try {
      final Response response = await wordWaveAPI.getProcessContent(
        userUid: userUid,
        mediaUid: mediaUid,
        processUid: processUid,
      );

      switch (response.statusCode) {
        case 200:
          final data = response.data['process'] as Map<String, dynamic>;

          WordWaveProcess process = WordWaveProcess.fromMap(data);
          return process;

        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAIException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to get status.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }
}
