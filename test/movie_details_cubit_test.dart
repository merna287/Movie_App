import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movie_app/core/errors/failure.dart';
import 'package:movie_app/features/details/domain/entities/cast_member.dart';
import 'package:movie_app/features/details/domain/entities/crew_member.dart';
import 'package:movie_app/features/details/domain/entities/movie_credits.dart';
import 'package:movie_app/features/details/domain/entities/movie_details.dart';
import 'package:movie_app/features/details/domain/entities/movie_video.dart';
import 'package:movie_app/features/details/domain/repositories/details_repository.dart';
import 'package:movie_app/features/details/presentation/cubit/movie_details_cubit.dart';
import 'package:movie_app/features/details/presentation/cubit/movie_details_state.dart';

class _FakeDetailsRepository implements DetailsRepository {
  MovieDetails? details;
  MovieCredits credits = const MovieCredits(cast: [], crew: []);
  List<MovieVideo> videos = const [];
  Failure? detailsFailure;
  Failure? creditsFailure;
  Failure? videosFailure;

  @override
  Future<AppResult<MovieDetails>> getMovieDetails(int movieId) async {
    if (detailsFailure != null) return Left(detailsFailure!);
    final value = details;
    if (value == null) return const Left(UnknownFailure());
    return Right(value);
  }

  @override
  Future<AppResult<MovieCredits>> getMovieCredits(int movieId) async {
    if (creditsFailure != null) return Left(creditsFailure!);
    return Right(credits);
  }

  @override
  Future<AppResult<List<MovieVideo>>> getMovieVideos(int movieId) async {
    if (videosFailure != null) return Left(videosFailure!);
    return Right(videos);
  }
}

const _details = MovieDetails(
  id: 550,
  title: 'Fight Club',
  overview: 'An insomniac office worker.',
  imageUrl: '',
  rating: 8.4,
  releaseYear: '1999',
  genre: 'Drama',
  runtimeMinutes: 139,
);

const _cast = [
  CastMember(id: 1, name: 'Brad Pitt', character: 'Tyler Durden', imageUrl: ''),
  CastMember(
    id: 2,
    name: 'Edward Norton',
    character: 'The Narrator',
    imageUrl: '',
  ),
];

const _crew = [
  CrewMember(id: 3, name: 'David Fincher', job: 'Director', imageUrl: ''),
  CrewMember(id: 4, name: 'Jim Uhls', job: 'Screenplay', imageUrl: ''),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeDetailsRepository repository;
  late MovieDetailsCubit cubit;

  setUp(() {
    repository = _FakeDetailsRepository()
      ..details = _details
      ..credits = const MovieCredits(cast: _cast, crew: _crew)
      ..videos = const [
        MovieVideo(key: 'abc', site: 'YouTube', type: 'Trailer'),
      ];
    cubit = MovieDetailsCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  test('loads details, cast, crew and picks the YouTube trailer', () async {
    await cubit.load(movieId: 550);

    final state = cubit.state as MovieDetailsLoaded;
    expect(state.details.runtimeMinutes, 139);
    expect(state.details.genre, 'Drama');
    expect(state.details.releaseYear, '1999');
    expect(state.cast.length, 2);
    expect(state.cast.first.character, 'Tyler Durden');
    expect(state.crew.length, 2);
    expect(state.crew.first.job, 'Director');
    expect(state.trailer?.watchUrl, 'https://www.youtube.com/watch?v=abc');
  });

  test(
    'prefers the Trailer over other YouTube videos, ignores non-YouTube',
    () async {
      repository.videos = const [
        MovieVideo(key: 'c1', site: 'YouTube', type: 'Bloopers'),
        MovieVideo(key: 'c2', site: 'Vimeo', type: 'Trailer'),
        MovieVideo(key: 'c3', site: 'YouTube', type: 'Teaser'),
        MovieVideo(key: 'c4', site: 'YouTube', type: 'Trailer'),
      ];

      await cubit.load(movieId: 550);

      expect((cubit.state as MovieDetailsLoaded).trailer?.key, 'c4');
    },
  );

  test('emits error when the details request fails', () async {
    repository.detailsFailure = const UnknownFailure();

    await cubit.load(movieId: 550);

    expect(cubit.state, isA<MovieDetailsError>());
  });

  test('degrades gracefully when credits and videos fail', () async {
    repository.creditsFailure = const UnknownFailure();
    repository.videosFailure = const UnknownFailure();

    await cubit.load(movieId: 550);

    final state = cubit.state as MovieDetailsLoaded;
    expect(state.cast, isEmpty);
    expect(state.crew, isEmpty);
    expect(state.trailer, isNull);
  });
}
