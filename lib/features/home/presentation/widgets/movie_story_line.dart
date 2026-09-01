import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class MovieStoryLine extends StatefulWidget {
  final String overview;

  const MovieStoryLine({super.key, required this.overview});

  @override
  State<MovieStoryLine> createState() => _MovieStoryLineState();
}

class _MovieStoryLineState extends State<MovieStoryLine> {
  static const int _maxCollapsedLines = 5;
  static const int _longTextThreshold = 140;

  bool _expanded = false;

  bool get _isLong => widget.overview.length > _longTextThreshold;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.storyLine.tr(),
          style: AppTypography.withColor(
            AppTypography.montserrat16W600,
            AppColors.primaryTextColor,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          widget.overview,
          style: AppTypography.withColor(
            AppTypography.montserrat13W500.copyWith(height: 1.55),
            AppColors.secondaryTextColor,
          ),
          maxLines: _expanded ? null : _maxCollapsedLines,
          overflow: _expanded ? null : TextOverflow.clip,
        ),
        if (_isLong)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                _expanded ? LocaleKeys.showLess.tr() : LocaleKeys.readMore.tr(),
                style: AppTypography.withColor(
                  AppTypography.montserrat13W500.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  AppColors.primaryColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
