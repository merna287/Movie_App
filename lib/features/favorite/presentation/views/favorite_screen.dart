import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/common/widgets/app_screen_header.dart';
import 'package:movie_app/core/dialogs/app_toast.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:movie_app/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:movie_app/features/favorite/presentation/widgets/favorite_confirm_dialog.dart';
import 'package:movie_app/features/favorite/presentation/widgets/favorite_empty_state.dart';
import 'package:movie_app/features/favorite/presentation/widgets/favorite_loading_shimmer.dart';
import 'package:movie_app/features/favorite/presentation/widgets/favorite_movie_card.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteCubit>(
      create: (_) => getIt<FavoriteCubit>()..load(),
      child: const _FavoriteView(),
    );
  }
}

class _FavoriteView extends StatelessWidget {
  const _FavoriteView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<FavoriteCubit, FavoriteState>(
        listenWhen: (prev, curr) =>
            curr is FavoriteLoaded && curr.errorMessage != null,
        listener: (context, state) {
          if (state is FavoriteLoaded && state.errorMessage != null) {
            AppToast.showToast(
              context,
              state.errorMessage!,
              type: ToastType.error,
            );
          }
        },
        builder: (context, state) => SafeArea(
          child: Column(
            children: [
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: AppScreenHeader(title: LocaleKeys.favorite.tr()),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: switch (state) {
                  FavoriteInitial() ||
                  FavoriteLoading() =>
                    const FavoriteLoadingShimmer(),
                  FavoriteError(:final message) =>
                    _ErrorView(message: message),
                  FavoriteRemoving(:final movies) =>
                    _LoadedList(movies: movies, removing: true),
                  FavoriteLoaded(:final movies) when movies.isEmpty =>
                    const FavoriteEmptyState(),
                  FavoriteLoaded(:final movies) =>
                    _LoadedList(movies: movies),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadedList extends StatelessWidget {
  final List<Movie> movies;
  final bool removing;

  const _LoadedList({required this.movies, this.removing = false});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: movies.length,
      separatorBuilder: (_, _) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return FavoriteMovieCard(
          movie: movie,
          removing: removing,
          onRemove: () => _confirmRemove(context, movie),
        );
      },
    );
  }

  Future<void> _confirmRemove(BuildContext context, Movie movie) async {
    if (!context.mounted) return;

    final confirmed = await FavoriteConfirmDialog.show(context);
    if (!confirmed || !context.mounted) return;

    context.read<FavoriteCubit>().removeMovie(movie.id);
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.withColor(
                AppTypography.montserrat12W500,
                AppColors.grayColor,
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => context.read<FavoriteCubit>().load(),
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
}
