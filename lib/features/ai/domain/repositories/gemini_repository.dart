import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/ai/domain/entities/chat_message.dart';

abstract class GeminiRepository {
  Future<AppResult<GeminiReply>> sendMessage({
    required String message,
    String? previousInteractionId,
  });
}
