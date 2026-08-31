class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.themoviedb.org/3';

  static const String discoverMovies = '$baseUrl/discover/movie';
  static const String movieCategories = '$baseUrl/genre/movie/list';
  static const String popularMovies = '$baseUrl/movie/popular';
  static const String nowPlayingMovies = '$baseUrl/movie/now_playing';
  static const String topRatedMovies = '$baseUrl/movie/top_rated';
  static const String searchMovies = '$baseUrl/search/movie';

  static String movieDetails(int movieId) => '$baseUrl/movie/$movieId';

  static String movieCredits(int movieId) => '$baseUrl/movie/$movieId/credits';

  static String movieImages(int movieId) => '$baseUrl/movie/$movieId/images';

  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';

  static String imageUrl(String path, {String size = 'w500'}) =>
      path.isEmpty ? '' : '$imageBaseUrl/$size$path';

  static String favoriteMovies(String accountId) =>
      '$baseUrl/account/$accountId/favorite/movies';

  static String favoriteMovie(String accountId) =>
      '$baseUrl/account/$accountId/favorite';

  static String ratedMovies(String accountId) =>
      '$baseUrl/account/$accountId/rated/movies';

  static String rateMovie(int movieId) => '$baseUrl/movie/$movieId/rating';

  static String watchListMovies(String accountId) =>
      '$baseUrl/account/$accountId/watchlist/movies';

  static String watchList(String accountId) =>
      '$baseUrl/account/$accountId/watchlist';

  static String accountDetails(String accountId) =>
      '$baseUrl/account/$accountId';
}
