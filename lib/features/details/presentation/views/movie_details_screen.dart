import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:movie_app/core/dialogs/app_toast.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/details/presentation/cubit/movie_details_cubit.dart';
import 'package:movie_app/features/details/presentation/cubit/movie_details_state.dart';
import 'package:movie_app/features/details/presentation/widgets/movie_action_buttons.dart';
import 'package:movie_app/features/details/presentation/widgets/movie_cast_and_crew.dart';
import 'package:movie_app/features/details/presentation/widgets/movie_details_header.dart';
import 'package:movie_app/features/details/presentation/widgets/movie_details_metadata.dart';
import 'package:movie_app/features/details/presentation/widgets/movie_details_shimmer.dart';
import 'package:movie_app/features/details/presentation/widgets/movie_error_view.dart';
import 'package:movie_app/features/details/presentation/widgets/movie_poster.dart';
import 'package:movie_app/features/details/presentation/widgets/movie_poster_backdrop.dart';
import 'package:movie_app/features/details/presentation/widgets/movie_rating.dart';
import 'package:movie_app/features/details/presentation/widgets/movie_story_line.dart';
import 'package:movie_app/features/details/presentation/share/share_modal.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.sizeOf(context).height * 0.60,
            child: IgnorePointer(
              child: MoviePosterBackdrop(imageUrl: movie.imageUrl),
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
          _showErrorToast(context, state.message);
        }
      },
      builder: (context, state) => _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, MovieDetailsState state) {
    if (state is MovieDetailsInitial || state is MovieDetailsLoading) {
      return const MovieDetailsShimmer();
    }

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
          Center(child: MoviePoster(imageUrl: movie.imageUrl)),
          SizedBox(height: 22.h),
          MovieDetailsMetadata(
            year: year.isEmpty ? null : year,
            runtimeMinutes: runtime,
            genre: genre.isEmpty ? null : genre,
          ),
          SizedBox(height: 10.h),
          MovieRating(rating: movie.rating),
          SizedBox(height: 16.h),
          switch (state) {
            MovieDetailsInitial() ||
            MovieDetailsLoading() => const SizedBox.shrink(),
            MovieDetailsError(:final message) => MovieErrorView(
              message: message,
              onRetry: () => _retry(context),
            ),
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

  void _retry(BuildContext context) {
    context.read<MovieDetailsCubit>().load(movieId: widget.movie.id);
  }

  Future<void> _handlePlay(BuildContext context) async {
    final state = context.read<MovieDetailsCubit>().state;
    final trailer = state is MovieDetailsLoaded ? state.trailer : null;

    if (trailer == null) {
      _showErrorToast(context, LocaleKeys.noTrailerAvailable.tr());
      return;
    }

    final uri = Uri.tryParse(trailer.watchUrl);
    final isValidUrl =
        uri != null &&
        uri.hasAuthority &&
        (uri.scheme == 'https' || uri.scheme == 'http');
    if (!isValidUrl) {
      _showErrorToast(context, LocaleKeys.unexpectedError.tr());
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        _showErrorToast(context, LocaleKeys.unexpectedError.tr());
      }
    } catch (_) {
      if (context.mounted) {
        _showErrorToast(context, LocaleKeys.unexpectedError.tr());
      }
    }
  }

  Future<void> _handleShare(BuildContext context) async {
    ShareModal.show(
      context,
      shareUrl: 'https://www.themoviedb.org/movie/${widget.movie.id}',
    );
  }

  void _showErrorToast(BuildContext context, String message) {
    AppToast.showToast(context, message, type: ToastType.error);
  }
}
