/// Minimal TMDB configuration.
///
/// Credentials are injected at build time via:
///
/// ```bash
/// flutter run \
///   --dart-define=TMDB_READ_ACCESS_TOKEN=<your_token> \
///   --dart-define=TMDB_ACCOUNT_ID=<your_account_id> \
///   --dart-define=GEMINI_API_KEY=<your_gemini_api_key>
/// ```
///
/// Or use `--dart-define-from-file=.env` with the same variable names.
///
/// They are intentionally kept out of source control so no real secret is
/// committed to the repository.
class ApiConfig {
  ApiConfig._();

  /// Read Access token used for public (unauthenticated) TMDB requests.
  static const String readAccessToken = String.fromEnvironment(
    'TMDB_READ_ACCESS_TOKEN',
  );

  /// TMDB account id required by account-scoped endpoints such as favorites.
  static const String accountId = String.fromEnvironment(
    'TMDB_ACCOUNT_ID',
  );

  /// Gemini API key used by the AI chat feature.
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
  );
}
