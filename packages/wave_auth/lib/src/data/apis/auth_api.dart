// ignore_for_file: unused_field, unused_import

import 'package:dio/dio.dart';
import 'package:wave_core/wave_core.dart';

class AuthAPI extends API {
  final String baseRoute = 'auth';

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

  /// Signs up a user.
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> signUp(
    String email,
    String password, {
    String? username,
    int? age,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    // Construct the URL for the signUp request.
    final String url = '$baseUrl/$baseRoute/signup';

    // Construct the body for the signUp request.
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'username': username,
      'age': age,
      'image_url': imageUrl,
      'data': data,
    };

    // Send a POST request to the server and await the response.
    final Response response = await post(
      url,
      body: body,
    );

    return response;
  }
}
