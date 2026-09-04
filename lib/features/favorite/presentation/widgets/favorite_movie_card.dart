import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/widgets/localized_genre.dart';

class FavoriteMovieCard extends StatelessWidget {
  final Movie movie;
  final bool removing;
  final VoidCallback onRemove;

  const FavoriteMovieCard({
    super.key,
    required this.movie,
    this.removing = false,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327.w,
      height: 107.h,
      padding: EdgeInsets.all(12.r),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.boxColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _MovieImage(movie: movie),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizedGenreName(movie.genre),
                  style: AppTypography.withColor(
                    AppTypography.montserrat13W500,
                    AppColors.whiteGreyColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                  movie.title,
                  style: AppTypography.withColor(
                    AppTypography.montserrat14W600.copyWith(height: 1.2),
                    AppColors.primaryTextColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      LocaleKeys.movie.tr(),
                      style: AppTypography.withColor(
                        AppTypography.montserrat12W500,
                        AppColors.grayColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.ratingStarColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      movie.rating.toStringAsFixed(1),
                      style: AppTypography.withColor(
                        AppTypography.montserrat12W500,
                        AppColors.ratingStarColor,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: removing ? null : onRemove,
                      behavior: HitTestBehavior.opaque,
                      child: Icon(
                        Icons.favorite,
                        size: 22,
                        color: removing
                            ? AppColors.tertiaryTextColor
                            : AppColors.errorColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieImage extends StatelessWidget {
  final Movie movie;

  const _MovieImage({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        movie.imageUrl,
        width: 121.w,
        height: 83.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 121.w,
            height: 83.h,
            color: AppColors.headerButtonColor,
            child: const Icon(
              Icons.movie,
              size: 32,
              color: AppColors.tertiaryTextColor,
            ),
          );
        },
      ),
    );
  }
}
