import 'package:dio/dio.dart';

import '../../core/utils/errors/ai_exception.dart';
import '../../core/utils/helpers/custom_logs.dart';
import '../apis/researcher_wave_api.dart';
import '../enums/research_source.dart';
import '../model/research_wave/research_docs.dart';
import '../model/research_wave/research_output.dart';

class ResearcherWave {
  static final ResearcherWave instance =
      ResearcherWave(researcherWaveAPI: ResearcherWaveAPI());

  final ResearcherWaveAPI researcherWaveAPI;
  ResearcherWave({required this.researcherWaveAPI});

  /// Checks if the server is running.
  /// No arguments takes.
  /// Returns a [Futture <Map<String ,dynamic>>] containing the server response.
  Future<Map<String, dynamic>> checkServer() async {
    try {
      final Response response = await researcherWaveAPI.checkServer();
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
      rethrow;
    }
  }

  /// Runs the researcher wave algorithim.
  /// Takes three parameters (useruid[String],prompt[String],optional(conversationUid[String])?).
  /// Returns a [Future<ChatBotOutput>] containing the server response.
  Future<ResearchOutput> run({
    required String userUid,
    required String prompt,
    String? conversationUid,
    bool alpha = false,
    ResearchSource researchSource = ResearchSource.archive,
  }) async {
    try {
      final Response response = await researcherWaveAPI.run(
        userUid: userUid,
        prompt: prompt,
        conversationUid: conversationUid,
        alpha: alpha,
        researchSource: researchSource,
      );
      switch (response.statusCode) {
        case 200:
          final data = response.data['output'] as Map<String, dynamic>;
          ResearchOutput output = ResearchOutput.fromMap(data);
          return output;
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

  /// Get all docs researcher wave algorithm.
  ///
  /// Return a [Future<List<ResearchDocs>>] containing the server response.///List<uid>
  Future<List<ResearchDocs>> getdocs({
    required String userUid,
  }) async {
    try {
      final Response response = await researcherWaveAPI.getdocs(
        userUid: userUid,
      );
      switch (response.statusCode) {
        case 200:
          final data = response.data['docs'] as List<dynamic>;
          List<ResearchDocs> docsList = data
              .map((e) => ResearchDocs.fromMap(e as Map<String, dynamic>))
              .toList();
          return docsList;
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

  /// Get all conversation researcher wave algorithm.
  ///
  /// Return a [Future<List<dynamic>>] containing the server response.///List<uid>
  Future<List<dynamic>> getconversation({
    required String userUid,
  }) async {
    try {
      final Response response = await researcherWaveAPI.getconversation(
        userUid: userUid,
      );
      switch (response.statusCode) {
        case 200:
          final data = response.data['data'] as List<dynamic>;
          return data;
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
}
