// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import '../../core/values/config.dart';

class API {
  final dio = Dio();
  String get baseUrl => WaveConfig.baseUrl.toString();

  // Options for the Dio instance.
  Options jsonOptions = Options(
    headers: {'Content-type': 'application/json; charset=UTF-8'},
    responseType: ResponseType.json,
  );

  Options formOptions = Options(
    headers: {'Content-type': 'multipart/form-data'},
    responseType: ResponseType.json,
  );

  Options dispositionOptions = Options(
    headers: {
      'Content-Disposition': 'attachment',
      'Connection': 'keep-alive',
    },
    receiveTimeout: const Duration(),
  );

  /// Checks if the server is running.
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> checkServer() async {
    // Construct the URL for the checkServer request.
    final String url = baseUrl;

    // Send a GET request to the server and await the response.
    final Response response = await dio.get(
      url,
    );

    return response;
  }

  /// get request
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> get(String url, {Map<String, dynamic>? headers}) async {
    // Send a GET request to the server and await the response.
    try {
      final Response response = await dio.get(
        url,
        options: jsonOptions.copyWith(headers: headers),
      );

      return response;
    } on DioException catch (e) {
      if (e.response == null) rethrow;
      return e.response!;
    }
  }

  /// post request
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> post(String url,
      {Map<String, dynamic>? headers,
      Object? body,
      ProgressCallback? onSendProgress,
      int sendTimeout = 0}) async {
    try {
      final Response response;
      // Check if the body is a dio FormData.
      if (body is FormData) {
        // Send a POST request to the server and await the response.
        response = await dio.post(
          url,
          options: jsonOptions.copyWith(headers: headers),
          data: body,
          onSendProgress: onSendProgress,
        );
      } else {
        // Send a POST request to the server and await the response.
        response = await dio.post(
          url,
          options: jsonOptions.copyWith(
              headers: headers, sendTimeout: Duration(seconds: sendTimeout)),
          data: body != null ? jsonEncode(body) : null,
        );
      }

      return response;
    } on DioException catch (e) {
      if (e.response == null) rethrow;
      return e.response!;
    }
  }

  /// put request
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> put(String url,
      {Map<String, dynamic>? headers, Map<String, dynamic>? body}) async {
    // Send a PUT request to the server and await the response.

    try {
      final Response response = await dio.put(
        url,
        options: jsonOptions.copyWith(headers: headers),
        data: body != null ? jsonEncode(body) : null,
      );

      return response;
    } on DioException catch (e) {
      if (e.response == null) rethrow;
      return e.response!;
    }
  }

  /// delete request
  ///
  /// Returns a [Future<Response>] containing the server response.
  Future<Response> delete(String url, {Map<String, dynamic>? headers}) async {
    // Send a DELETE request to the server and await the response.
    try {
      final Response response = await dio.delete(
        url,
        options: jsonOptions.copyWith(headers: headers),
      );

      return response;
    } on DioException catch (e) {
      if (e.response == null) rethrow;
      return e.response!;
    }
  }

  /// download file
  ///
  /// Return a [Future<Response>] containing the server response.
  Future<Response> download(String urlPath,
      {Map<String, dynamic>? headers}) async {
    // Send a Download request to the server and await the response.

    bool isdirDownloadExists = true;
    dynamic directory;
    //Construct the path for download the file.
    directory = "/storage/emulated/0/Download/";
    isdirDownloadExists = await Directory(directory).exists(); //true or false
    //the differences between android versions we need to check
    if (isdirDownloadExists) {
      directory = "/storage/emulated/0/Download/aiwave";
    } else {
      directory = "/storage/emulated/0/Downloads/aiwave";
    }
    try {
      final Response response = await dio.download(
        urlPath,
        directory + "/test.mp4",
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != -1) {
            // Calculate the download progress percentage

            // ignore: unused_local_variable
            double progress = (receivedBytes / totalBytes) * 100;
            log(
              'percentage: ${(receivedBytes / totalBytes * 100).toStringAsFixed(0)}%',
            );
          }
        },
        options: dispositionOptions.copyWith(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      if (e.response == null) rethrow;
      return e.response!;
    }
  }
}
