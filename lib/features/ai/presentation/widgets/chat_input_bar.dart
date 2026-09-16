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

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isSending,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: BoxConstraints(minHeight: 44.h),
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: AppColors.boxColor,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: TextField(
                  controller: controller,
                  enabled: !isSending,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: isSending ? null : (_) => onSend(),
                  style: AppTypography.withColor(
                    AppTypography.montserrat14W500,
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
                      AppTypography.montserrat14W500,
                      AppColors.tertiaryTextColor,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
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
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: isSending
                      ? AppColors.headerButtonColor
                      : AppColors.primaryColor,
                  shape: BoxShape.circle,
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
                          size: 20.w,
                          color: AppColors.primaryTextColor,
                        ),
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
