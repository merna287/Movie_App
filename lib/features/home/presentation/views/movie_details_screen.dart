import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_action_buttons.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_cast_and_crew.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_details_header.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_details_metadata.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_story_line.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;
  final int? runtimeMinutes;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
    this.runtimeMinutes,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: MovieDetailsHeader(
                  title: movie.title,
                  onBack: () => Navigator.of(context).pop(),
                ),
              ),
              SizedBox(height: 16.h),
              Center(child: _buildPoster(movie.imageUrl)),
              SizedBox(height: 24.h),
              MovieDetailsMetadata(
                movie: movie,
                runtimeMinutes: widget.runtimeMinutes,
              ),
              SizedBox(height: 12.h),
              _buildRating(movie.rating),
              SizedBox(height: 22.h),
              MovieActionButtons(
                isFavorite: _isFavorite,
                onFavoriteToggle: _toggleFavorite,
              ),
              SizedBox(height: 28.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: MovieStoryLine(overview: movie.overview),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const MovieCastAndCrew(),
              ),
              SizedBox(height: 36.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoster(String imageUrl) {
    return SizedBox(
      width: 200.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.headerButtonColor,
                child: Icon(
                  Icons.movie,
                  size: 56.w,
                  color: AppColors.tertiaryTextColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRating(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.star, size: 18, color: AppColors.ratingStarColor),
        SizedBox(width: 6.w),
        Text(
          rating.toStringAsFixed(1),
          style: AppTypography.withColor(
            AppTypography.montserrat14W600,
            AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}
