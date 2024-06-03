// ignore_for_file: unused_field, unused_import

import 'package:dio/dio.dart';
import 'package:wave_core/wave_core.dart';

class StorageAPI extends API {
  final String baseRoute = 'storage';

  /// Signs in a user.
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> signIn(String email, String password) async {
    // Construct the URL for the signIn request.
    final String url = '$baseUrl/$baseRoute/signin';

    // Construct the body for the signIn request.
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };

    // Send a POST request to the server and await the response.
    final Response response = await post(
      url,
      body: body,
    );

    return response;
  }

  /// Ai upload
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> aiUpload({
    required String uid,
    required List<String> paths,
    ProgressCallback? onSendProgress,
  }) async {
    // Construct the URL for the upload request.
    final String url = '$baseUrl/$baseRoute/ai/upload';

    // Construct the header for the upload request.
    final Map<String, dynamic> headers = {'x-user-id': uid};

    // Construct the body for the upload request.
    final formData = FormData.fromMap({
      'files': paths.map((p) => MultipartFile.fromFileSync(p)).toList(),
    });

    // Send a POST request to the server and await the response.
    final Response response = await post(
      url,
      headers: headers,
      body: formData,
      onSendProgress: onSendProgress,
    );

    return response;
  }

  /// Upload
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> upload({
    required List<String> paths,
    String? filesDir,
    ProgressCallback? onSendProgress,
  }) async {
    // Construct the URL for the upload request.
    final String url = '$baseUrl/$baseRoute/upload';

    // Construct the body for the upload request.
    final formData = FormData.fromMap({
      'files_dir': filesDir,
      'files': paths.map((p) => MultipartFile.fromFileSync(p)).toList(),
    });

    // Send a POST request to the server and await the response.
    final Response response =
        await post(url, body: formData, onSendProgress: onSendProgress);

    return response;
  }

  /// Folders
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> folders({String? folder}) async {
    // Construct the URL for the folders request.
    folder ??= '';
    final String url = '$baseUrl/$baseRoute/folders/$folder';

    // Send a GET request to the server and await the response.
    final Response response = await get(
      url,
    );

    return response;
  }

  /// Media Download
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> downloadMedia({
    required String uid,
    required String urlPath,
    String? fileName,
  }) async {
    // Construct the URL for the upload request.

    // Construct the header for the upload request.
    final Map<String, dynamic> headers = {
      'x-user-id': uid,
      'Content-Disposition': 'attachment; filename="$fileName"',
    };

    final Response response = await download(urlPath, headers: headers);
    return response;
  }
}
