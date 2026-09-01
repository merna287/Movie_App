import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class MovieCastMember {
  final int id;
  final String name;
  final String imageUrl;

  const MovieCastMember({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class MovieCastAndCrew extends StatelessWidget {
  final List<MovieCastMember> cast;

  const MovieCastAndCrew({super.key, this.cast = const []});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.castAndCrew.tr(),
          style: AppTypography.withColor(
            AppTypography.montserrat16W600,
            AppColors.primaryTextColor,
          ),
        ),
        SizedBox(height: 12.h),
        if (cast.isEmpty)
          Text(
            LocaleKeys.castAndCrewComingSoon.tr(),
            style: AppTypography.withColor(
              AppTypography.montserrat12W500,
              AppColors.grayColor,
            ),
          )
        else
          SizedBox(
            height: 104.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: cast.length,
              itemBuilder: (context, index) {
                final member = cast[index];
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : 14.w),
                  child: Column(
                    children: [
                      Container(
                        width: 72.w,
                        height: 72.w,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColors.headerButtonColor,
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          member.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person_outline,
                              size: 28,
                              color: AppColors.grayColor,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 6.h),
                      SizedBox(
                        width: 72.w,
                        child: Text(
                          member.name,
                          style: AppTypography.withColor(
                            AppTypography.montserrat12W500.copyWith(
                              fontSize: 11,
                            ),
                            AppColors.grayColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
