import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/common/widgets/app_screen_header.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/ai/presentation/cubit/gemini_chat_cubit.dart';
import 'package:movie_app/features/ai/presentation/cubit/gemini_chat_state.dart';
import 'package:movie_app/features/ai/presentation/widgets/chat_input_bar.dart';
import 'package:movie_app/features/ai/presentation/widgets/chat_message_bubble.dart';

class GeminiChatScreen extends StatelessWidget {
  const GeminiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GeminiChatCubit>(),
      child: const _GeminiChatView(),
    );
  }
}

class _GeminiChatView extends StatefulWidget {
  const _GeminiChatView();

  @override
  State<_GeminiChatView> createState() => _GeminiChatViewState();
}

class _GeminiChatViewState extends State<_GeminiChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;

    context.read<GeminiChatCubit>().sendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocConsumer<GeminiChatCubit, GeminiChatState>(
          listenWhen: (previous, current) =>
              previous.messages.length != current.messages.length ||
              previous.isSending != current.isSending ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            _scrollToBottom();
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 12.h),
                  child: AppScreenHeader(
                    title: LocaleKeys.aiAssistant.tr(),
                  ),
                ),
                if (state.errorMessage != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 8.h),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.boxColor,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.errorColor.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        state.errorMessage!,
                        style: AppTypography.withColor(
                          AppTypography.montserrat12W500.copyWith(height: 1.4),
                          AppColors.errorColor,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: state.messages.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Text(
                              LocaleKeys.aiChatEmptyHint.tr(),
                              textAlign: TextAlign.center,
                              style: AppTypography.withColor(
                                AppTypography.montserrat14W500.copyWith(
                                  height: 1.5,
                                ),
                                AppColors.tertiaryTextColor,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 8.h),
                          itemCount:
                              state.messages.length + (state.isSending ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.messages.length) {
                              return Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 16.w,
                                        height: 16.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        LocaleKeys.aiThinking.tr(),
                                        style: AppTypography.withColor(
                                          AppTypography.montserrat12W500,
                                          AppColors.tertiaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return ChatMessageBubble(
                              message: state.messages[index],
                            );
                          },
                        ),
                ),
                ChatInputBar(
                  controller: _controller,
                  onSend: _sendMessage,
                  isSending: state.isSending,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
