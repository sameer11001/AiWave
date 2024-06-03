// ignore_for_file: unused_field, unused_import

import 'package:dio/dio.dart';
import 'package:wave_core/wave_core.dart';

class UsersAPI extends API {
  final String baseRoute = 'users';

  /// Gets a user by uid.
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> getUser(String uid) async {
    // Construct the URL for the getUser request.
    final String url = '$baseUrl/$baseRoute/$uid';

    // Send a GET request to the server and await the response.
    final Response response = await dio.get(url);

    return response;
  }

  /// Updates a user.
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> updateUser(String uid,
      {String? username,
      int? age,
      String? imageUrl,
      Map<String, dynamic>? data}) async {
    // Construct the URL for the updateUser request.
    final String url = '$baseUrl/$baseRoute/$uid/update';

    // Construct the body for the updateUser request.
    final Map<String, dynamic> body = {
      'username': username,
      'age': age,
      'image_url': imageUrl,
      'data': data,
    };

    // Send a PUT request to the server and await the response.
    final Response response = await put(url, body: body);

    return response;
  }

  /// Deletes a user.
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> deleteUser(String uid) async {
    // Construct the URL for the deleteUser request.
    final String url = '$baseUrl/$baseRoute/$uid/delete';

    // Send a DELETE request to the server and await the response.
    final Response response = await delete(url);

    return response;
  }

  /// Gets a user's attributes.
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> getUserAttributes(String userUid, String attributes) async {
    // Construct the URL for the getUserAttributes request.
    final String url = '$baseUrl/$baseRoute/$userUid/$attributes';

    // Send a GET request to the server and await the response.
    final Response response = await dio.get(url);

    return response;
  }

  /// Media Delete
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> deleteMedia(
    String uid,
    String mediaUid,
  ) async {
    // Construct the URL for the upload request.
    final String url = '$baseUrl/$baseRoute/$uid/media/$mediaUid/delete';

    // Send a delete request to the server and await the response.
    final Response response = await delete(
      url,
    );
    return response;
  }

  /// Get Process By mediaUid
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> getProcessByMediaUid(String uid, String mediaUid) async {
    // Construct the URL for the getUserAttributes request.
    final String url = '$baseUrl/$baseRoute/$uid/media/$mediaUid/ai_processes';

    // Send a GET request to the server and await the response.
    final Response response = await get(url);
    return response;
  }

  /// Get porcesses by process UID
  ///
  ///  Returns a [Future<Response>] containing the server response.
  Future<Response> getProcessesByProcessUid(
      String uid, String processUid, String mediaUid) async {
    // Construct the URL for the getUserAttributes request.
    final String url =
        '$baseUrl/$baseRoute/$uid/media/$mediaUid/ai_processes/$processUid';
    // Send a GET request to the server and await the response.
    final Response response = await get(url);
    return response;
  }

  /// Process Delete
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> deleteProcessByProcessUid(
      String uid, String mediaUid, String processUid) async {
    // Construct the URL for the upload request.
    final String url =
        '$baseUrl/$baseRoute/$uid/media/$mediaUid/ai_processes/$processUid/delete';

    // Send a delete request to the server and await the response.
    final Response response = await delete(
      url,
    );
    return response;
  }
}
