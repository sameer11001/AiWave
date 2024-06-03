import 'package:dio/dio.dart';
import 'package:wave_core/wave_core.dart';

class WaveAIException implements WaveCoreException {
  @override
  final String message;
  @override
  final int? statusCode;
  @override
  final String code;

  WaveAIException({
    this.message = 'An unknown error occurred.',
    this.code = 'unknown',
    this.statusCode,
  });

  @override
  String toString() => '[$statusCode].$message. Error code: $code';

  static WaveAIException fromRespone(Response response) {
    final String message =
        response.data['error'] ?? 'An unknown error occurred.';
    final String code = response.data['code'] ?? 'unknown';
    final int? statusCode = response.statusCode;

    return WaveAIException(
      message: message,
      code: code,
      statusCode: statusCode,
    );
  }
}
