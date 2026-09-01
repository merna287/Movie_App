import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class MovieSectionEmpty extends StatelessWidget {
  final bool hasQuery;

  const MovieSectionEmpty({super.key, required this.hasQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.movie_outlined,
            size: 56.w,
            color: AppColors.tertiaryTextColor,
          ),
          SizedBox(height: 12.h),
          Text(
            hasQuery
                ? LocaleKeys.noMoviesFound.tr()
                : LocaleKeys.noMoviesAvailable.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
