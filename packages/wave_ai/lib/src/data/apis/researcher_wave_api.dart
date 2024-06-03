import 'package:dio/dio.dart';
import 'package:wave_ai/src/data/enums/research_source.dart';

import 'ai_api.dart';

class ResearcherWaveAPI extends AIAPI {
  @override

  // ignore: overridden_fields
  final String baseRoute = 'researcher_wave';

  ///Runs the researcher wave algorithm
  ///
  ///Returns a [Future<Response>] containing the server response.
  Future<Response> run({
    required String userUid,
    required String prompt,
    String? conversationUid,
    ResearchSource researchSource = ResearchSource.archive,
    bool alpha = false,
  }) async {
    // Create the url of the request
    final String url =
        '$baseUrl/${super.baseRoute}/$baseRoute/chatbot${alpha ? "-alpha" : ""}';

    // Create the headers of the request
    final Map<String, dynamic> headers = {'x-user-id': userUid};

    // Create the body of the request
    final Map<String, dynamic> body = {
      'prompt': prompt,
      'conversation_uid': conversationUid,
      'source': researchSource.name,
    };

    final Response response =
        await post(url, headers: headers, body: body, sendTimeout: 120);
    return response;
  }

  /// Get all docs of the researcher wave algorithm.
  ///
  /// Retuen a [Future<Response>] containing the server response.
  Future<Response> getdocs({
    required String userUid,
  }) async {
    final String url = '$baseUrl/${super.baseRoute}/$baseRoute/docs';
    final Map<String, dynamic> headers = {'x-user-id': userUid};
    Response response = await get(
      url,
      headers: headers,
    );
    return response;
  }

  /// Get all chat conversation of the researcher wave algorithm.
  ///
  /// Retuen a [Future<Response>] containing the server response.
  Future<Response> getconversation({
    required String userUid,
  }) async {
    final String url = '$baseUrl/$baseRoute/conversations';
    final Map<String, dynamic> headers = {'x-user-id': userUid};

    Response response = await post(
      url,
      headers: headers,
    );
    return response;
  }

  /// Get single eva conversation by uid of the researcher wave algorithm.
  ///
  /// Retuen a [Future<Response>] containing the server response.
  Future<Response> getconversationbyUid({
    required String userUid,
    required String conversationUid,
  }) async {
    final String url = '$baseUrl/$baseRoute/conversations/$conversationUid';

    final Map<String, dynamic> headers = {
      'x-user-id': userUid,
    };

    Response response = await post(url, headers: headers);

    return response;
  }
}
