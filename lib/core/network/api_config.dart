/// Minimal TMDB configuration.
///
/// The Read Access Token is injected at build time via:
///
/// ```bash
/// flutter run --dart-define=TMDB_READ_ACCESS_TOKEN=<your_token>
/// ```
///
/// It is intentionally kept out of source control so no real secret is
/// committed to the repository.
class ApiConfig {
  ApiConfig._();

  static const String readAccessToken = String.fromEnvironment(
    'TMDB_READ_ACCESS_TOKEN',
  );
}
