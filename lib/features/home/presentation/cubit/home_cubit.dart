import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/network/api_config.dart';
import 'package:movie_app/features/home/domain/repositories/home_repository.dart';
import 'package:movie_app/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(const HomeInitial());

  Future<void> loadFeaturedMovies() async {
    if (ApiConfig.readAccessToken.isEmpty) {
      debugPrint('TMDB token configured: false');
      emit(const HomeError('TMDB token is missing. Add it to your .env file.'));
      return;
    }

    emit(const HomeLoading());

    final result = await _repository.getFeaturedMovies();

    result.fold((failure) => emit(HomeError(_mapFailureToMessage(failure))), (
      movies,
    ) {
      debugPrint('TMDB: ${movies.length} featured movies loaded');
      emit(HomeSuccess(movies));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return LocaleKeys.noInternetConnection.tr();
    }
    if (failure is ServerFailure) {
      final statusCode = failure.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        return 'TMDB authentication failed. Check your API token.';
      }
      if (statusCode != null) {
        return 'TMDB request failed (HTTP $statusCode).';
      }
      return failure.serverMessage ?? LocaleKeys.unexpectedError.tr();
    }
    if (failure is ParsingFailure) {
      return 'Failed to parse TMDB response.';
    }
    return LocaleKeys.unexpectedError.tr();
  }
}
