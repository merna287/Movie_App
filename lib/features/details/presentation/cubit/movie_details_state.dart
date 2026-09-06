import 'package:movie_app/features/details/domain/entities/cast_member.dart';
import 'package:movie_app/features/details/domain/entities/crew_member.dart';
import 'package:movie_app/features/details/domain/entities/movie_details.dart';
import 'package:movie_app/features/details/domain/entities/movie_video.dart';

sealed class MovieDetailsState {
  const MovieDetailsState();
}

final class MovieDetailsInitial extends MovieDetailsState {
  const MovieDetailsInitial();
}

final class MovieDetailsLoading extends MovieDetailsState {
  const MovieDetailsLoading();
}

final class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetails details;
  final List<CastMember> cast;
  final List<CrewMember> crew;
  final MovieVideo? trailer;

  const MovieDetailsLoaded({
    required this.details,
    required this.cast,
    required this.crew,
    this.trailer,
  });
}

final class MovieDetailsError extends MovieDetailsState {
  final String message;

  const MovieDetailsError(this.message);
}
