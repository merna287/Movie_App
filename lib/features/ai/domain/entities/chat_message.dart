enum ChatMessageRole { user, assistant }

class ChatMessage {
  final String id;
  final ChatMessageRole role;
  final String text;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.text,
  });

  factory ChatMessage.user(String text, {String? id}) {
    return ChatMessage(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      role: ChatMessageRole.user,
      text: text,
    );
  }

  factory ChatMessage.assistant(String text, {String? id}) {
    return ChatMessage(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      role: ChatMessageRole.assistant,
      text: text,
    );
  }

  bool get isUser => role == ChatMessageRole.user;
}

class GeminiReply {
  final String interactionId;
  final String text;

  const GeminiReply({
    required this.interactionId,
    required this.text,
  });
}
