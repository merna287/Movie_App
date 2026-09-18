import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/common/widgets/app_screen_header.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/ai/domain/entities/chat_message.dart';
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
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
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
    if (_isEditing) {
      setState(() {
        _isEditing = false;
      });
    }
  }

  void _onEditMessage(ChatMessage message) {
    setState(() {
      _isEditing = true;
      _controller.text = message.text;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
    _focusNode.requestFocus();
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _controller.clear();
    });
  }

  void _onCopyResponse(String text) {
    Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          LocaleKeys.aiCopied.tr(),
          style: AppTypography.withColor(
            AppTypography.montserrat12W500,
            AppColors.primaryTextColor,
          ),
        ),
        backgroundColor: AppColors.boxColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
      ),
    );
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
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF301B20),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.errorColor.withValues(alpha: 0.45),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 16.sp,
                            color: AppColors.errorColor,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              state.errorMessage!,
                              style: AppTypography.withColor(
                                AppTypography.montserrat12W500.copyWith(height: 1.4),
                                AppColors.errorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: state.messages.isEmpty
                      ? Center(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 28.w,
                              vertical: 16.h,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 64.w,
                                  height: 64.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF193B47), Color(0xFF132832)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withValues(alpha: 0.45),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryColor.withValues(alpha: 0.15),
                                        blurRadius: 16,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.auto_awesome,
                                      size: 28.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  LocaleKeys.aiAssistant.tr(),
                                  textAlign: TextAlign.center,
                                  style: AppTypography.withColor(
                                    AppTypography.montserrat18W600.copyWith(
                                      fontSize: 18.sp,
                                      letterSpacing: 0.3,
                                    ),
                                    AppColors.primaryTextColor,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  LocaleKeys.aiChatEmptyHint.tr(),
                                  textAlign: TextAlign.center,
                                  style: AppTypography.withColor(
                                    AppTypography.montserrat14W500.copyWith(
                                      fontSize: 13.sp,
                                      height: 1.5,
                                    ),
                                    AppColors.tertiaryTextColor,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8.h,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    _buildPromptChip('🎬 Top movies to watch'),
                                    _buildPromptChip('⭐ Best sci-fi films'),
                                    _buildPromptChip('🍿 Recommend a thriller'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 8.h),
                          itemCount:
                              state.messages.length + (state.isSending ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.messages.length) {
                              return Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF242735),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(18.r),
                                      topRight: Radius.circular(18.r),
                                      bottomLeft: Radius.circular(4.r),
                                      bottomRight: Radius.circular(18.r),
                                    ),
                                    border: Border.all(
                                      color: const Color(0xFF35394B),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 14.w,
                                        height: 14.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        LocaleKeys.aiThinking.tr(),
                                        style: AppTypography.withColor(
                                          AppTypography.montserrat12W500.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          AppColors.tertiaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final message = state.messages[index];
                            return ChatMessageBubble(
                              message: message,
                              onEdit: message.isUser
                                  ? () => _onEditMessage(message)
                                  : null,
                              onCopy: !message.isUser
                                  ? () => _onCopyResponse(message.text)
                                  : null,
                            );
                          },
                        ),
                ),
                ChatInputBar(
                  controller: _controller,
                  focusNode: _focusNode,
                  onSend: _sendMessage,
                  isSending: state.isSending,
                  isEditing: _isEditing,
                  onCancelEdit: _cancelEdit,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPromptChip(String prompt) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _controller.text = prompt;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: prompt.length),
          );
          _focusNode.requestFocus();
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFF242735),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: const Color(0xFF35394B),
              width: 1,
            ),
          ),
          child: Text(
            prompt,
            style: AppTypography.withColor(
              AppTypography.montserrat12W500.copyWith(
                fontSize: 12.sp,
              ),
              AppColors.whiteGreyColor,
            ),
          ),
        ),
      ),
    );
  }
}
