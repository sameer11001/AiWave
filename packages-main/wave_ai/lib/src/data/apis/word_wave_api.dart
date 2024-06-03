// ignore_for_file: file_names

import 'package:dio/dio.dart';

import '../../../wave_ai.dart';
import 'ai_api.dart';

class WordWaveAPI extends AIAPI {
  @override
  // ignore: overridden_fields
  final String baseRoute = 'word_wave';

  /// Runs the word wave algorithm.
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> run({
    required String userUid,
    required String mediaUid,
    Language language = Language.auto,
    WordWaveTask task = WordWaveTask.defaultTask,
  }) async {
    // Construct the URL for the signIn request.
    final String url = '$baseUrl/${super.baseRoute}/$baseRoute/run';

    // Construct the body for the signIn request.
    final Map<String, dynamic> headers = {
      'x-user-id': userUid,
    };

    // Construct the body for the signIn request.
    final Map<String, dynamic> body = {
      'media_uid': mediaUid,
      'language_code': language.name,
      'task': task.name,
    };

    // Send a POST request to the server and await the response.
    final Response response = await post(
      url,
      headers: headers,
      body: body,
    );

    return response;
  }

  /// Check the status of the word wave algorithm.
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> getStatus({
    required String userUid,
    required String statusUid,
  }) async {
    // Construct the URL for the signIn request.
    final String url =
        '$baseUrl/${super.baseRoute}/$baseRoute/status/$statusUid';

    // Construct the body for the signIn request.
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

  /// Get all processes of the word wave algorithm.
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

  /// Get process of the word wave algorithm.
  ///
  /// Returns a [Future<Response>] containing the server response.
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

  /// Get the process content
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> getProcessContent({
    required String userUid,
    required String mediaUid,
    required String processUid,
  }) async {
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
