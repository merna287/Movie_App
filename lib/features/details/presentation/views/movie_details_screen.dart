import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:movie_app/core/dialogs/app_toast.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/cubit/movie_details_cubit.dart';
import 'package:movie_app/features/home/presentation/cubit/movie_details_state.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_action_buttons.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_cast_and_crew.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_details_header.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_details_metadata.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_story_line.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;
  final int? runtimeMinutes;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
    this.runtimeMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: _MoviePosterBackdrop(imageUrl: movie.imageUrl),
            ),
          ),
          SafeArea(
            child: BlocProvider<MovieDetailsCubit>(
              create: (_) =>
                  getIt<MovieDetailsCubit>()..load(movieId: movie.id),
              child: _MovieDetailsView(
                movie: movie,
                initialRuntimeMinutes: runtimeMinutes,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieDetailsView extends StatefulWidget {
  final Movie movie;
  final int? initialRuntimeMinutes;

  const _MovieDetailsView({required this.movie, this.initialRuntimeMinutes});

  @override
  State<_MovieDetailsView> createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<_MovieDetailsView> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieDetailsCubit, MovieDetailsState>(
      listener: (context, state) {
        if (state is MovieDetailsError) {
          AppToast.showToast(context, state.message, type: ToastType.error);
        }
      },
      builder: (context, state) => _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, MovieDetailsState state) {
    final movie = widget.movie;
    final details = state is MovieDetailsLoaded ? state.details : null;

    final String year = (details?.releaseYear.isNotEmpty ?? false)
        ? details!.releaseYear
        : movie.releaseYear;
    final int? runtime =
        details?.runtimeMinutes ?? widget.initialRuntimeMinutes;
    final String genre = (details?.genre.isNotEmpty ?? false)
        ? details!.genre
        : movie.genre;

    return SingleChildScrollView(
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
          SizedBox(height: 22.h),
          MovieDetailsMetadata(
            year: year.isEmpty ? null : year,
            runtimeMinutes: runtime,
            genre: genre.isEmpty ? null : genre,
          ),
          SizedBox(height: 10.h),
          _buildRating(movie.rating),
          SizedBox(height: 16.h),
          switch (state) {
            MovieDetailsInitial() || MovieDetailsLoading() => _buildLoading(),
            MovieDetailsError(:final message) => _buildError(context, message),
            MovieDetailsLoaded() => const SizedBox.shrink(),
          },
          SizedBox(height: 6.h),
          MovieActionButtons(
            isFavorite: _isFavorite,
            onFavoriteToggle: _toggleFavorite,
            onPlay: () => _handlePlay(context),
            onShare: () => _handleShare(context),
          ),
          SizedBox(height: 28.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: MovieStoryLine(overview: movie.overview),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: state is MovieDetailsLoaded
                ? MovieCastAndCrew(cast: state.cast, crew: state.crew)
                : const MovieCastAndCrew(),
          ),
          SizedBox(height: 36.h),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Center(
        child: SizedBox(
          width: 20.w,
          height: 20.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                message,
                style: AppTypography.withColor(
                  AppTypography.montserrat12W500,
                  AppColors.grayColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 8.w),
            TextButton(
              onPressed: () => _retry(context),
              child: Text(
                LocaleKeys.retry.tr(),
                style: AppTypography.withColor(
                  AppTypography.montserrat12W500.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _retry(BuildContext context) {
    context.read<MovieDetailsCubit>().load(movieId: widget.movie.id);
  }

  Future<void> _handlePlay(BuildContext context) async {
    final state = context.read<MovieDetailsCubit>().state;
    final trailer = state is MovieDetailsLoaded ? state.trailer : null;

    if (trailer == null) {
      AppToast.showToast(
        context,
        LocaleKeys.noTrailerAvailable.tr(),
        type: ToastType.error,
      );
      return;
    }

    final launched = await launchUrl(
      Uri.parse(trailer.watchUrl),
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      AppToast.showToast(
        context,
        LocaleKeys.unexpectedError.tr(),
        type: ToastType.error,
      );
    }
  }

  Future<void> _handleShare(BuildContext context) async {
    final state = context.read<MovieDetailsCubit>().state;
    final title = state is MovieDetailsLoaded
        ? state.details.title
        : widget.movie.title;

    try {
      await Share.share(
        LocaleKeys.checkOutMovie.tr(namedArgs: {'title': title}),
      );
    } catch (_) {
      if (context.mounted) {
        AppToast.showToast(
          context,
          LocaleKeys.unexpectedError.tr(),
          type: ToastType.error,
        );
      }
    }
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
          rating.toString(),
          style: AppTypography.withColor(
            AppTypography.montserrat14W600,
            AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}

class _MoviePosterBackdrop extends StatelessWidget {
  final String imageUrl;

  const _MoviePosterBackdrop({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundColor.withValues(alpha: 0.08),
              AppColors.backgroundColor.withValues(alpha: 0.22),
              AppColors.backgroundColor.withValues(alpha: 0.48),
              AppColors.backgroundColor.withValues(alpha: 0.88),
              AppColors.backgroundColor,
            ],
            stops: const [0.0, 0.42, 0.52, 0.62, 1.0],
          ),
        ),
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
