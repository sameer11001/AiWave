// ignore_for_file: unnecessary_getters_setters

import 'dart:async';

import 'package:dio/dio.dart';

import '../../core/utils/errors/ai_exception.dart';
import '../../core/utils/helpers/custom_logs.dart';
import '../apis/ai_api.dart';
import 'researcher_wave_service.dart';
import 'vision_wave_service.dart';
import 'word_wave_service.dart';

class WaveAI {
  static final WaveAI instance = WaveAI(aiAPI: AIAPI());

  final AIAPI aiAPI;

  WaveAI({
    required this.aiAPI,
  });

  /// Checks if the server is running.
  ///
  /// Returns a [Future<Map<String, dynamic>>] containing the server response.
  Future<Map<String, dynamic>> checkServer() async {
    try {
      final Response response = await aiAPI.checkServer();

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

  /// Gets the [WordWave] service.
  WordWave get wordWave => WordWave.instance;

  /// Gets the [VisionWave] service.
  VisionWave get visionWave => VisionWave.instance;

  /// Gets the [ChatBot] service.
  ResearcherWave get researcherWave => ResearcherWave.instance;

}
