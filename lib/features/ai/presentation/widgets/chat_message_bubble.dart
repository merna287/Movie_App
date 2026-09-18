import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/ai/domain/entities/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onEdit;
  final VoidCallback? onCopy;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onEdit,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.82.sw),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isUser ? null : const Color(0xFF242735),
          gradient: isUser
              ? const LinearGradient(
                  colors: [Color(0xFF0E7079), Color(0xFF094E55)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(isUser ? 18.r : 4.r),
            bottomRight: Radius.circular(isUser ? 4.r : 18.r),
          ),
          border: Border.all(
            color: isUser
                ? const Color(0xFF148B96).withValues(alpha: 0.45)
                : const Color(0xFF35394B),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isUser ? 0.16 : 0.22),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isUser) ...[
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 13.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      LocaleKeys.aiAssistant.tr(),
                      style: AppTypography.withColor(
                        AppTypography.montserrat12W500.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                        AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (isUser)
              Text(
                message.text,
                style: AppTypography.withColor(
                  AppTypography.montserrat14W500.copyWith(
                    fontSize: 14.sp,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                  AppColors.primaryTextColor,
                ),
              )
            else
              _buildAiContent(message.text),
            if (isUser && onEdit != null) ...[
              SizedBox(height: 8.h),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          size: 12.sp,
                          color: AppColors.primaryTextColor.withValues(alpha: 0.9),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          LocaleKeys.aiEdit.tr(),
                          style: AppTypography.withColor(
                            AppTypography.montserrat12W500.copyWith(
                              fontSize: 11.sp,
                              height: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                            AppColors.primaryTextColor.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ] else if (!isUser && onCopy != null) ...[
              SizedBox(height: 8.h),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onCopy,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1E2B),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFF35394B),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.copy_rounded,
                            size: 12.sp,
                            color: AppColors.tertiaryTextColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            LocaleKeys.aiCopy.tr(),
                            style: AppTypography.withColor(
                              AppTypography.montserrat12W500.copyWith(
                                fontSize: 11.sp,
                                height: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                              AppColors.tertiaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAiContent(String text) {
    final paragraphs = text.split(RegExp(r'\n{2,}'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((para) {
        final trimmed = para.trim();
        if (trimmed.isEmpty) return const SizedBox.shrink();

        final lines = trimmed.split('\n');
        if (lines.any((l) => _isListItem(l))) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines.map((line) => _buildLineItem(line)).toList(),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: _buildFormattedText(trimmed),
        );
      }).toList(),
    );
  }

  bool _isListItem(String line) {
    final t = line.trimLeft();
    return t.startsWith('* ') ||
        t.startsWith('- ') ||
        t.startsWith('• ') ||
        RegExp(r'^\d+\.\s').hasMatch(t);
  }

  Widget _buildLineItem(String line) {
    final t = line.trimLeft();
    final isBullet =
        t.startsWith('* ') || t.startsWith('- ') || t.startsWith('• ');
    final numberMatch = RegExp(r'^(\d+)\.\s').firstMatch(t);

    if (isBullet) {
      final content = t.substring(2);
      return Padding(
        padding: EdgeInsets.only(bottom: 4.h, left: 2.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 7.h, right: 8.w),
              child: Container(
                width: 5.w,
                height: 5.w,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Expanded(child: _buildFormattedText(content)),
          ],
        ),
      );
    } else if (numberMatch != null) {
      final prefix = numberMatch.group(1)!;
      final content = t.substring(numberMatch.end);
      return Padding(
        padding: EdgeInsets.only(bottom: 4.h, left: 2.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 18.w,
              child: Text(
                '$prefix.',
                style: AppTypography.withColor(
                  AppTypography.montserrat14W600.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                  AppColors.primaryColor,
                ),
              ),
            ),
            Expanded(child: _buildFormattedText(content)),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: _buildFormattedText(line),
    );
  }

  Widget _buildFormattedText(String text) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: AppTypography.withColor(
              AppTypography.montserrat14W500.copyWith(
                fontSize: 14.sp,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
              AppColors.whiteGreyColor,
            ),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: AppTypography.withColor(
            AppTypography.montserrat14W600.copyWith(
              fontSize: 14.sp,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
            AppColors.primaryTextColor,
          ),
        ),
      );
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: AppTypography.withColor(
            AppTypography.montserrat14W500.copyWith(
              fontSize: 14.sp,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
            AppColors.whiteGreyColor,
          ),
        ),
      );
    }

    return Text.rich(
      TextSpan(children: spans),
    );
  }
}

