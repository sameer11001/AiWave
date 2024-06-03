import 'package:dio/dio.dart';

class WaveCoreException implements Exception {
  final String message;
  final int? statusCode;
  final String code;

  WaveCoreException({
    this.message = 'An unknown error occurred.',
    this.code = 'unknown',
    this.statusCode,
  });

  @override
  String toString() => '[$statusCode].$message. Error code: $code';

  static WaveCoreException fromRespone(Response response) {
    final String message =
        response.data['error'] ?? 'An unknown error occurred.';
    final String code = response.data['code'] ?? 'unknown';
    final int? statusCode = response.statusCode;

    return WaveCoreException(
      message: message,
      code: code,
      statusCode: statusCode,
    );
  }
}
