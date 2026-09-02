import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/network/api_config.dart';
import 'package:movie_app/features/home/domain/entities/cast_member.dart';
import 'package:movie_app/features/home/domain/entities/crew_member.dart';
import 'package:movie_app/features/home/domain/entities/movie_credits.dart';
import 'package:movie_app/features/home/domain/entities/movie_details.dart';
import 'package:movie_app/features/home/domain/entities/movie_video.dart';
import 'package:movie_app/features/home/domain/repositories/home_repository.dart';
import 'package:movie_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movie_app/features/home/presentation/cubit/movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final HomeRepository _repository;

  MovieDetailsCubit(this._repository) : super(const MovieDetailsInitial());

  Future<void> load({required int movieId}) async {
    if (ApiConfig.readAccessToken.isEmpty) {
      debugPrint('TMDB token configured: false');
      emit(
        const MovieDetailsError(
          'TMDB token is missing. Add it to your .env file.',
        ),
      );
      return;
    }

    emit(const MovieDetailsLoading());

    // Details, credits and videos are independent requests: run them
    // concurrently so the page loads after roughly a single round trip.
    final results = await Future.wait<AppResult<Object?>>([
      _repository.getMovieDetails(movieId),
      _repository.getMovieCredits(movieId),
      _repository.getMovieVideos(movieId),
    ]);

    final detailsFailure = results[0].getLeft().toNullable();
    if (detailsFailure != null) {
      emit(MovieDetailsError(HomeCubit.failureMessage(detailsFailure)));
      return;
    }

    final details = results[0].getRight().toNullable()! as MovieDetails;

    // Credits and videos degrade gracefully: when unavailable the screen shows
    // the missing-data placeholders instead of failing the whole page.
    final movieCredits = results[1].getRight().toNullable() as MovieCredits?;
    final cast = movieCredits?.cast ?? const <CastMember>[];
    final crew = movieCredits?.crew ?? const <CrewMember>[];

    final videos =
        results[2].getRight().toNullable() as List<MovieVideo>? ??
        const <MovieVideo>[];

    emit(
      MovieDetailsLoaded(
        details: details,
        cast: cast,
        crew: crew,
        trailer: _pickTrailer(videos),
      ),
    );
  }

  MovieVideo? _pickTrailer(List<MovieVideo> videos) {
    MovieVideo? trailer;

    for (final video in videos) {
      if (!video.isUsableTrailer) continue;

      if (trailer == null ||
          (video.type.toLowerCase() == 'trailer' &&
              trailer.type.toLowerCase() != 'trailer')) {
        trailer = video;
      }
    }

    return trailer;
  }
}
