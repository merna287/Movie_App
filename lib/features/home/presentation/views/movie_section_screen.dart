import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/common/widgets/access_badge.dart';
import 'package:movie_app/core/common/widgets/app_screen_header.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/details/presentation/views/movie_details_screen.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/widgets/localized_genre.dart';
import 'package:shimmer/shimmer.dart';

class MovieSectionScreen extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final bool isLoading;

  const MovieSectionScreen({
    super.key,
    required this.title,
    required this.movies,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: AppScreenHeader(title: title.tr()),
            ),
            SizedBox(height: 20.h),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) return const _MovieListShimmer();
    if (movies.isEmpty) {
      return Center(
        child: Text(
          LocaleKeys.noMoviesAvailable.tr(),
          style: AppTypography.withColor(
            AppTypography.montserrat14W500,
            AppColors.tertiaryTextColor,
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      itemCount: movies.length,
      separatorBuilder: (_, _) => SizedBox(height: 20.h),
      itemBuilder: (context, index) => _MovieRow(movie: movies[index]),
    );
  }
}

class _MovieRow extends StatelessWidget {
  final Movie movie;

  const _MovieRow({required this.movie});

  // Runtime is not available in the current Movie entity, so it is rendered
  // as a static UI placeholder matching the reference. The Premium/Free badge
  // is driven by the movie's shared access status.
  String get _durationText =>
      LocaleKeys.minutes.tr(namedArgs: {'count': '148'});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => MovieDetailsScreen(movie: movie)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Poster(movie: movie),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccessBadge(isPremium: movie.isPremium),
                SizedBox(height: 8.h),
                Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.withColor(
                    AppTypography.montserrat16W600,
                    AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                _MetaRow(icon: AppAssets.calendarIcon, text: movie.releaseYear),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    _MetaRow(icon: AppAssets.clockIcon, text: _durationText),
                    SizedBox(width: 8.w),
                    const _Pg13Badge(),
                  ],
                ),
                SizedBox(height: 6.h),
                _MetaRow(
                  icon: AppAssets.filmIcon,
                  text: '${localizedGenreName(movie.genre)}  |  Movie',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  final Movie movie;

  const _Poster({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: 112.w,
        height: 147.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.headerButtonColor,
                  child: Icon(
                    Icons.movie,
                    size: 36.w,
                    color: AppColors.tertiaryTextColor,
                  ),
                );
              },
            ),
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.ratingBadgeBackgroundColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 12.w,
                      color: AppColors.ratingStarColor,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      movie.rating.toString(),
                      style: AppTypography.withColor(
                        AppTypography.montserrat12W500,
                        AppColors.ratingStarColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon, width: 16.w, height: 16.w),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.withColor(
              AppTypography.montserrat12W500,
              AppColors.grayColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _Pg13Badge extends StatelessWidget {
  const _Pg13Badge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        'PG-13',
        style: AppTypography.withColor(
          AppTypography.montserrat12W500,
          AppColors.primaryColor,
        ),
      ),
    );
  }
}

class _MovieListShimmer extends StatelessWidget {
  const _MovieListShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.boxColor,
      highlightColor: AppColors.headerButtonColor,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
        itemCount: 5,
        separatorBuilder: (_, _) => SizedBox(height: 20.h),
        itemBuilder: (context, index) => const _MovieRowShimmer(),
      ),
    );
  }
}

class _MovieRowShimmer extends StatelessWidget {
  const _MovieRowShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _shimmerBox(width: 112.w, height: 147.h, radius: 12),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerBox(width: 65.w, height: 20.h, radius: 4),
              SizedBox(height: 8.h),
              _shimmerBox(width: 150.w, height: 18.h, radius: 4),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _shimmerBox(width: 16.w, height: 16.w),
                  SizedBox(width: 6.w),
                  _shimmerBox(width: 60.w, height: 12.h),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  _shimmerBox(width: 16.w, height: 16.w),
                  SizedBox(width: 6.w),
                  _shimmerBox(width: 80.w, height: 12.h),
                  SizedBox(width: 8.w),
                  _shimmerBox(width: 40.w, height: 16.h, radius: 4),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  _shimmerBox(width: 16.w, height: 16.w),
                  SizedBox(width: 6.w),
                  _shimmerBox(width: 70.w, height: 12.h),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _shimmerBox({
  required double width,
  required double height,
  double radius = 8,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.boxColor,
      borderRadius: BorderRadius.circular(radius.r),
    ),
  );
}
