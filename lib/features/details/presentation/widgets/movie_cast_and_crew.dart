import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/details/domain/entities/cast_member.dart';
import 'package:movie_app/features/details/domain/entities/crew_member.dart';

class MovieCastAndCrew extends StatelessWidget {
  final List<CastMember> cast;
  final List<CrewMember> crew;

  const MovieCastAndCrew({
    super.key,
    this.cast = const [],
    this.crew = const [],
  });

  static const List<String> _preferredJobs = [
    'Director',
    'Writer',
    'Screenplay',
    'Producer',
  ];

  @override
  Widget build(BuildContext context) {
    final crewRows = _buildCrewRows();

    if (cast.isEmpty && crewRows.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          SizedBox(height: 12.h),
          Text(
            LocaleKeys.castAndCrewComingSoon.tr(),
            style: AppTypography.withColor(
              AppTypography.montserrat12W500,
              AppColors.grayColor,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        if (cast.isNotEmpty) ...[SizedBox(height: 12.h), _castList()],
        if (crewRows.isNotEmpty) ...[SizedBox(height: 16.h), ...crewRows],
      ],
    );
  }

  Widget _title() {
    return Text(
      LocaleKeys.castAndCrew.tr(),
      style: AppTypography.withColor(
        AppTypography.montserrat16W600,
        AppColors.primaryTextColor,
      ),
    );
  }

  Widget _castList() {
    return SizedBox(
      height: 118.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: cast.length,
        itemBuilder: (context, index) {
          final member = cast[index];
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 14.w),
            child: SizedBox(
              width: 72.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _avatar(member.imageUrl),
                  SizedBox(height: 6.h),
                  Text(
                    member.name,
                    style: AppTypography.withColor(
                      AppTypography.montserrat12W500.copyWith(fontSize: 11),
                      AppColors.grayColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  if (member.character.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      member.character,
                      style: AppTypography.withColor(
                        AppTypography.montserrat12W500.copyWith(fontSize: 10),
                        AppColors.whiteGreyColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _avatar(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        width: 72.w,
        height: 72.w,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.headerButtonColor,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(
            Icons.person_outline,
            size: 28,
            color: AppColors.grayColor,
          ),
        ),
      );
    }

    return Container(
      width: 72.w,
      height: 72.w,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.headerButtonColor,
        shape: BoxShape.circle,
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.person_outline,
              size: 28,
              color: AppColors.grayColor,
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildCrewRows() {
    final rows = <Widget>[];
    final labelStyle = AppTypography.withColor(
      AppTypography.montserrat12W500.copyWith(fontWeight: FontWeight.w600),
      AppColors.grayColor,
    );
    final nameStyle = AppTypography.withColor(
      AppTypography.montserrat12W500,
      AppColors.primaryTextColor,
    );

    for (final job in _preferredJobs) {
      final names = crew
          .where((member) => member.job == job)
          .map((member) => member.name)
          .where((name) => name.isNotEmpty)
          .take(2)
          .toList();

      if (names.isEmpty) continue;

      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_jobLabel(job), style: labelStyle),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  names.join(', '),
                  style: nameStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return rows;
  }

  String _jobLabel(String job) {
    return switch (job) {
      'Director' => LocaleKeys.director.tr(),
      'Writer' => LocaleKeys.writer.tr(),
      'Screenplay' => LocaleKeys.screenplay.tr(),
      'Producer' => LocaleKeys.producer.tr(),
      _ => job,
    };
  }
}
