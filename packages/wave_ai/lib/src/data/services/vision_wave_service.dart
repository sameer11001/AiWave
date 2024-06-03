import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:wave_storage/wave_storage.dart';

import '../../../wave_ai.dart';
import '../../core/utils/helpers/custom_logs.dart';
import '../apis/vision_wave_api.dart';

class VisionWave {
  static final VisionWave instance = VisionWave(visionWaveAPI: VisionWaveAPI());

  final VisionWaveAPI visionWaveAPI;

  VisionWave({
    required this.visionWaveAPI,
  });

  /// Checks if the server is running.
  /// No arguments takes.
  /// Returns a [Future<Map<String, dynamic>>] containing the server response.
  Future<Map<String, dynamic>> checkServer() async {
    try {
      final Response response = await visionWaveAPI.checkServer();

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

  /// Runs the vision wave algorithm.
  /// Takes 5 parameters (userUid[String],mediaUid[String],
  /// filters[List<dynamic?>](optional),tracking[boolean?](optional),task[String?](optional)).
  /// Returns a [Future<Status>] containing the server response.
  /// store it into VisionWaveStatus u can access it.
  Future<VisionWaveStatus> run({
    required String userUid,
    required String mediaUid,
    List<VisionObject>? filters,
    bool? tracking = false,
    VisionWaveTask task = VisionWaveTask.detect,
  }) async {
    try {
      // Check if the filters is all
      if (filters != null && filters.contains(VisionObject.all)) {
        // Set the filters to null
        filters = null;
      }

      final Response response = await visionWaveAPI.run(
        userUid: userUid,
        mediaUid: mediaUid,
        filters: filters?.map((e) => e.idx).toList(),
        tracking: tracking,
        task: task,
      );

      switch (response.statusCode) {
        case 200:
          final data = response.data['status'] as Map<String, dynamic>;
          VisionWaveStatus status = VisionWaveStatus.fromMap(data);
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

  /// Gets the status of the vision wave algorithm.
  /// Takes two parameters (useruid[String],statusuid[String]).
  /// Returns a [Future<Status>] containing the server response.
  /// store it into VisionWaveStatus u can access it.
  Future<VisionWaveStatus> getStatus({
    required String userUid,
    required String statusUid,
  }) async {
    try {
      final Response response = await visionWaveAPI.getStatus(
        userUid: userUid,
        statusUid: statusUid,
      );
      switch (response.statusCode) {
        case 200:
          final data = response.data['status'] as Map<String, dynamic>;
          VisionWaveStatus status = VisionWaveStatus.fromMap(data);
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

  /// Gets the process of the vision wave algorithm.
  /// Takes one parameters (userUid[String]).
  /// Returns a [Future<List<dynamic>>] containing the server response.
  /// Return List<String> but for prevent any error i put dynamic.
  Future<List<AIMedia>> getAllMedia({required userUid}) async {
    try {
      final Response response =
          await visionWaveAPI.getAllMedia(userUid: userUid);
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

  /// Gets the process by Uid of the vision wave algorithm.
  /// Takes two parameters (userUid[String], mediaUid[String]).
  /// Returns a [Future<proccess>] containing the server response.
  Future<AIMedia> getMediaByUid({
    required String userUid,
    required String mediaUid,
  }) async {
    try {
      final Response response = await visionWaveAPI.getMediaByUid(
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
  Future<VisionWaveProcess> getProcessContent({
    required String userUid,
    required String mediaUid,
    required String processUid,
  }) async {
    try {
      final Response response = await visionWaveAPI.getProcessContent(
        userUid: userUid,
        mediaUid: mediaUid,
        processUid: processUid,
      );

      switch (response.statusCode) {
        case 200:
          final data = response.data['process'] as Map<String, dynamic>;

          VisionWaveProcess process = VisionWaveProcess.fromMap(data);
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

  /// Runs the word wave algorithm and sets up status stream.
  Future<void> runWithStatusStream({
    required String userUid,
    required String statusUid,
    required StreamController<VisionWaveStatus> statusController,
  }) async {
    await _runStatusCheck({
      'action': 'startStatusCheck',
      'userUid': userUid,
      'statusUid': statusUid,
      'statusController': statusController,
    });
  }

  static Future<void> _runStatusCheck(Map<String, dynamic> message) async {
    final VisionWave visionWave = VisionWave.instance;
    if (message['action'] == 'startStatusCheck') {
      final String userUid = message['userUid'];
      final String statusUid = message['statusUid'];
      final StreamController<VisionWaveStatus> statusController =
          message['statusController'];
      VisionWaveStatus? prevStatus;
      bool isFirst = true;
      while (true) {
        try {
          final Response response = await visionWave.visionWaveAPI.getStatus(
            userUid: userUid,
            statusUid: statusUid,
          );

          switch (response.statusCode) {
            case 200:
              final data = response.data['status'] as Map<String, dynamic>;
              VisionWaveStatus status = VisionWaveStatus.fromMap(data);
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
    final VisionWave visionWave = VisionWave.instance;

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
            final Response response = await visionWave.visionWaveAPI.getStatus(
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
}
