import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;
  final FocusNode? focusNode;
  final bool isEditing;
  final VoidCallback? onCancelEdit;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isSending,
    this.focusNode,
    this.isEditing = false,
    this.onCancelEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isEditing)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2633),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        size: 14.sp,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          LocaleKeys.aiEditingMessage.tr(),
                          style: AppTypography.withColor(
                            AppTypography.montserrat12W500.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            AppColors.whiteGreyColor,
                          ),
                        ),
                      ),
                      if (onCancelEdit != null)
                        GestureDetector(
                          onTap: onCancelEdit,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: EdgeInsets.all(2.w),
                            child: Icon(
                              Icons.close_rounded,
                              size: 16.sp,
                              color: AppColors.tertiaryTextColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(minHeight: 46.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF242735),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: const Color(0xFF35394B),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      enabled: !isSending,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: isSending ? null : (_) => onSend(),
                      style: AppTypography.withColor(
                        AppTypography.montserrat14W500.copyWith(
                          fontSize: 14.sp,
                          height: 1.4,
                        ),
                        AppColors.primaryTextColor,
                      ),
                      cursorColor: AppColors.primaryColor,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: LocaleKeys.aiChatHint.tr(),
                        hintStyle: AppTypography.withColor(
                          AppTypography.montserrat14W500.copyWith(
                            fontSize: 14.sp,
                          ),
                          AppColors.tertiaryTextColor,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 13.h),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Semantics(
                  button: true,
                  label: LocaleKeys.aiSend.tr(),
                  child: GestureDetector(
                    onTap: isSending ? null : onSend,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 46.w,
                      height: 46.w,
                      decoration: BoxDecoration(
                        gradient: isSending
                            ? null
                            : const LinearGradient(
                                colors: [Color(0xFF12CDD9), Color(0xFF0C9AA4)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        color: isSending ? AppColors.headerButtonColor : null,
                        shape: BoxShape.circle,
                        boxShadow: isSending
                            ? null
                            : [
                                BoxShadow(
                                  color: AppColors.primaryColor.withValues(alpha: 0.28),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Center(
                        child: isSending
                            ? SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : Icon(
                                Icons.send_rounded,
                                size: 19.w,
                                color: AppColors.primaryTextColor,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
