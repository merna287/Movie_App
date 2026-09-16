import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/ai/data/api/gemini_api.dart';
import 'package:movie_app/features/ai/data/services/movie_context_enricher.dart';
import 'package:movie_app/features/ai/domain/constants/movie_assistant_prompt.dart';
import 'package:movie_app/features/ai/domain/entities/chat_message.dart';
import 'package:movie_app/features/ai/domain/repositories/gemini_repository.dart';

class GeminiRepositoryImpl implements GeminiRepository {
  final GeminiApi _api;
  final MovieContextEnricher _movieContextEnricher;

  GeminiRepositoryImpl(this._api, this._movieContextEnricher);

  @override
  Future<AppResult<GeminiReply>> sendMessage({
    required String message,
    String? previousInteractionId,
  }) async {
    final enrichedInput = await _movieContextEnricher.enrichInput(message);
    final isFirstTurn =
        previousInteractionId == null || previousInteractionId.trim().isEmpty;

    return _api.createInteraction(
      input: enrichedInput,
      previousInteractionId: previousInteractionId,
      systemInstruction:
          isFirstTurn ? MovieAssistantPrompt.systemInstruction : null,
    );
  }
}
