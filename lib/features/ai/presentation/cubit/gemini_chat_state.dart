import 'package:movie_app/features/ai/domain/entities/chat_message.dart';

class GeminiChatState {
  final List<ChatMessage> messages;
  final bool isSending;
  final String? errorMessage;
  final String? previousInteractionId;

  const GeminiChatState({
    this.messages = const [],
    this.isSending = false,
    this.errorMessage,
    this.previousInteractionId,
  });

  GeminiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isSending,
    String? errorMessage,
    bool clearError = false,
    String? previousInteractionId,
    bool clearInteraction = false,
  }) {
    return GeminiChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      previousInteractionId: clearInteraction
          ? null
          : (previousInteractionId ?? this.previousInteractionId),
    );
  }
}
