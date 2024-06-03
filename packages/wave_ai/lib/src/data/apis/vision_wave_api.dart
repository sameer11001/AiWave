import 'package:dio/dio.dart';

import '../enums/vision_wave_task.dart';
import 'ai_api.dart';

class VisionWaveAPI extends AIAPI {
  @override
  // ignore: overridden_fields
  final String baseRoute = 'vision_wave';

  Future<Response> run({
    required String userUid,
    required String mediaUid,
    List<int>? filters,
    bool? tracking = false,
    VisionWaveTask task = VisionWaveTask.detect,
  }) async {
    // Construct the URL for the run visionWave request.
    final String url = '$baseUrl/${super.baseRoute}/$baseRoute/run';

    // Construct the header for the run request.
    final Map<String, dynamic> headers = {
      'x-user-id': userUid,
    };

    // Construct the body for the run request.
    final Map<String, dynamic> body = {
      'media_uid': mediaUid,
      'filters': filters,
      'tracking': tracking,
      'task': task.name,
    };

    // Send a POST request to the server and await the response.
    final Response response = await post(url, headers: headers, body: body);
    return response;
  }

  Future<Response> getStatus({
    required String userUid,
    required String statusUid,
  }) async {
    // Construct the URL for the signIn request.
    final String url =
        '$baseUrl/${super.baseRoute}/$baseRoute/status/$statusUid';

    // Construct the header for the signIn request.
    final Map<String, dynamic> headers = {
      'x-user-id': userUid,
    };

    // Send a GET request to the server and await the response.
    final Response response = await get(
      url,
      headers: headers,
    );

    return response;
  }

  Future<Response> getClasses() async {
    // Construct the URL for the classes request.
    final String url = '$baseUrl/${super.baseRoute}/$baseRoute/classes';
    final Response response = await get(url);
    return response;
  }

  /// Get all processes of the vision wave algorithm.
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> getAllMedia({
    required userUid,
  }) async {
    // Construct the URL for the Process request.
    final String url = '$baseUrl/${super.baseRoute}/$baseRoute/media';

    // Construct the header for the Process request.
    final Map<String, dynamic> headers = {
      'x-user-id': userUid,
    };

    // Send a POST request to the server and await the response.
    final Response response = await get(url, headers: headers);
    return response;
  }

  Future<Response> getMediaByUid({
    required String userUid,
    required String mediaUid,
  }) async {
    // Construct the URL for the Process request.
    final String url = '$baseUrl/${super.baseRoute}/$baseRoute/media/$mediaUid';

    // Construct the header for the process request.
    final Map<String, dynamic> headers = {
      'x-user-id': userUid,
    };

    // Send a GET request to the server and await the response.
    final Response response = await get(
      url,
      headers: headers,
    );
    return response;
  }

  /// Get process by uid of the vision wave algorithm.
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> getProcessContent(
      {required String userUid,
      required String mediaUid,
      required String processUid}) async {
    // Construct the URL for the Process request.
    final String url =
        '$baseUrl/${super.baseRoute}/$baseRoute/media/$mediaUid/$processUid/content';

    // Construct the header for the process request.
    final Map<String, dynamic> headers = {
      'x-user-id': userUid,
    };

    // Send a GET request to the server and await the response.
    final Response response = await get(
      url,
      headers: headers,
    );
    return response;
  }
}
