import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/network/api_config.dart';
import 'package:movie_app/features/ai/domain/entities/chat_message.dart';
import 'package:movie_app/features/ai/domain/repositories/gemini_repository.dart';
import 'package:movie_app/features/ai/presentation/cubit/gemini_chat_state.dart';

class GeminiChatCubit extends Cubit<GeminiChatState> {
  final GeminiRepository _repository;

  GeminiChatCubit(this._repository) : super(const GeminiChatState());

  void clearError() {
    if (state.errorMessage == null) return;
    emit(state.copyWith(clearError: true));
  }

  Future<void> sendMessage(String rawMessage) async {
    final message = rawMessage.trim();
    if (message.isEmpty) {
      emit(state.copyWith(errorMessage: LocaleKeys.aiEmptyMessage.tr()));
      return;
    }

    if (state.isSending) return;

    if (ApiConfig.geminiApiKey.isEmpty) {
      emit(state.copyWith(errorMessage: LocaleKeys.aiGeminiApiKeyMissing.tr()));
      return;
    }

    final userMessage = ChatMessage.user(message);
    final pendingMessages = [...state.messages, userMessage];
    final previousInteractionId = state.previousInteractionId;

    emit(
      state.copyWith(
        messages: pendingMessages,
        isSending: true,
        clearError: true,
      ),
    );

    final result = await _repository.sendMessage(
      message: message,
      previousInteractionId: previousInteractionId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          messages: pendingMessages,
          isSending: false,
          errorMessage: _mapFailure(failure),
        ),
      ),
      (reply) => emit(
        state.copyWith(
          messages: [...pendingMessages, ChatMessage.assistant(reply.text)],
          isSending: false,
          previousInteractionId: reply.interactionId,
        ),
      ),
    );
  }

  String _mapFailure(Failure failure) {
    if (failure is NetworkFailure) {
      return LocaleKeys.aiChatError.tr();
    }

    if (failure is AuthFailure) {
      return LocaleKeys.aiGeminiApiKeyMissing.tr();
    }

    if (failure is ServerFailure) {
      final statusCode = failure.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        return LocaleKeys.aiInvalidApiKey.tr();
      }
      return LocaleKeys.aiChatError.tr();
    }

    if (failure is ParsingFailure) {
      return LocaleKeys.aiChatError.tr();
    }

    return LocaleKeys.unexpectedError.tr();
  }
}
