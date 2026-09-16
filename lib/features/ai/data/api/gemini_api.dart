import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/core/errors/app_exception.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/errors/safe_api_call.dart';
import 'package:movie_app/core/network/api_config.dart';
import 'package:movie_app/features/ai/domain/entities/chat_message.dart';

class GeminiApi {
  static const String interactionsUrl =
      'https://generativelanguage.googleapis.com/v1beta/interactions';
  static const String model = 'gemini-3.5-flash';
  static const String apiRevision = '2026-05-20';
  static const Duration requestTimeout = Duration(seconds: 60);

  final http.Client _client;

  GeminiApi({http.Client? client}) : _client = client ?? http.Client();

  Future<AppResult<GeminiReply>> createInteraction({
    required String input,
    String? previousInteractionId,
    String? systemInstruction,
  }) {
    return safeApiCall(() async {
      final apiKey = ApiConfig.geminiApiKey;
      if (apiKey.isEmpty) {
        throw const AuthException('Gemini API key is missing');
      }

      final body = <String, dynamic>{
        'model': model,
        'input': input,
        if (systemInstruction != null &&
            systemInstruction.trim().isNotEmpty)
          'system_instruction': systemInstruction.trim(),
        if (previousInteractionId != null &&
            previousInteractionId.trim().isNotEmpty)
          'previous_interaction_id': previousInteractionId,
      };

      final http.Response response;
      try {
        response = await _client
            .post(
              Uri.parse(interactionsUrl),
              headers: {
                'Content-Type': 'application/json',
                'x-goog-api-key': apiKey,
                'Api-Revision': apiRevision,
              },
              body: jsonEncode(body),
            )
            .timeout(requestTimeout);
      } on TimeoutException {
        throw const NetworkException('Gemini request timed out');
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw ServerException(
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      if (response.statusCode != 200) {
        throw ServerException(
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ParsingException();
      }

      final interactionId = decoded['id']?.toString().trim();
      final text = _extractOutputText(decoded);

      if (interactionId == null ||
          interactionId.isEmpty ||
          text == null ||
          text.isEmpty) {
        throw const ParsingException();
      }

      return GeminiReply(interactionId: interactionId, text: text);
    });
  }

  static String? _extractOutputText(Map<String, dynamic> json) {
    final directOutput = json['output_text'];
    if (directOutput is String && directOutput.trim().isNotEmpty) {
      return directOutput.trim();
    }

    final outputs = json['outputs'];
    if (outputs is List) {
      for (final output in outputs.reversed) {
        final text = _readTextPart(output);
        if (text != null) return text;
      }
    }

    final steps = json['steps'];
    if (steps is List) {
      for (final step in steps.reversed) {
        if (step is! Map<String, dynamic>) continue;
        if (step['type'] != 'model_output') continue;

        final content = step['content'];
        if (content is! List) continue;

        for (final part in content.reversed) {
          final text = _readTextPart(part);
          if (text != null) return text;
        }
      }
    }

    return null;
  }

  static String? _readTextPart(Object? part) {
    if (part is! Map<String, dynamic>) return null;

    final type = part['type']?.toString();
    if (type != null && type != 'text') return null;

    final text = part['text']?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }
}
