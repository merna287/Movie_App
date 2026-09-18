import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:movie_app/features/ai/data/api/gemini_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('createInteraction parses model_output steps from Interactions API', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), GeminiApi.interactionsUrl);
      expect(request.headers['Api-Revision'], GeminiApi.apiRevision);
      expect(request.headers['Content-Type'], 'application/json');
      expect(request.headers.containsKey('x-goog-api-key'), isTrue);

      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['model'], GeminiApi.model);
      expect(body['input'], 'Hello');

      return http.Response(
        jsonEncode({
          'id': 'interaction-123',
          'status': 'completed',
          'steps': [
            {'type': 'thought'},
            {
              'type': 'model_output',
              'content': [
                {'type': 'text', 'text': 'Hi there!'},
              ],
            },
          ],
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final api = GeminiApi(client: client);
    final result = await api.createInteraction(input: 'Hello');

    expect(result.isRight(), isTrue);
    final reply = result.getRight().toNullable()!;
    expect(reply.interactionId, 'interaction-123');
    expect(reply.text, 'Hi there!');
  });

  test('createInteraction forwards previous_interaction_id for context', () async {
    Map<String, dynamic>? capturedBody;
    final client = MockClient((request) async {
      capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(
        jsonEncode({
          'id': 'interaction-456',
          'output_text': 'Blue.',
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final api = GeminiApi(client: client);
    final result = await api.createInteraction(
      input: 'What is my favorite color?',
      previousInteractionId: 'interaction-123',
    );

    expect(result.isRight(), isTrue);
    expect(capturedBody?['previous_interaction_id'], 'interaction-123');
    expect(result.getRight().toNullable()!.text, 'Blue.');
  });

  test('createInteraction sends system_instruction on first turn', () async {
    Map<String, dynamic>? capturedBody;
    final client = MockClient((request) async {
      capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(
        jsonEncode({
          'id': 'interaction-789',
          'output_text': 'Try an action movie like Mad Max: Fury Road.',
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final api = GeminiApi(client: client);
    final result = await api.createInteraction(
      input: 'Recommend an action movie',
      systemInstruction: 'You are CINEMAX AI.',
    );

    expect(result.isRight(), isTrue);
    expect(capturedBody?['system_instruction'], 'You are CINEMAX AI.');
    expect(capturedBody?.containsKey('previous_interaction_id'), isFalse);
  });

  test('createInteraction returns failure for unauthorized response', () async {
    final client = MockClient((request) async {
      return http.Response('{"error":"invalid key"}', 401);
    });

    final api = GeminiApi(client: client);
    final result = await api.createInteraction(input: 'Hello');

    expect(result.isLeft(), isTrue);
  });
}
