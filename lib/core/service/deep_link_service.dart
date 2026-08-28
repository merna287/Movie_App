import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:movie_app/features/auth/create_new_password/presentation/views/create_new_password_screen.dart';

/// Handles incoming Android App Links / iOS Universal Links and directs
/// Firebase Auth action links (password reset) to the correct screen.
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  /// @Deprecated('Use [attach] instead')
  Future<Uri?> getInitialLink() => _appLinks.getInitialLink();

  /// @Deprecated('Use [attach] instead')
  void startListening() {
    _subscribe();
  }

  /// Starts listening for links received while the app is running and
  /// processes a link that launched the app (cold start). Should be called
  /// once, early in the app lifecycle.
  Future<void> attach() async {
    _subscribe();

    final initial = await _appLinks.getInitialLink();
    if (initial == null) return;
    // The Get navigator is only available after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleUri(initial);
    });
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _appLinks.uriLinkStream.listen(handleUri);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Processes a deep link. Currently handles Firebase password-reset links
  /// (`mode=resetPassword` + `oobCode`). Other/malformed links are ignored.
  void handleUri(Uri uri) {
    Uri actionUri = uri;

    final nestedLink = uri.queryParameters['link'];

    if (nestedLink != null && nestedLink.isNotEmpty) {
      final parsedLink = Uri.tryParse(nestedLink);

      if (parsedLink != null) {
        actionUri = parsedLink;
      }
    }

    final params = actionUri.queryParameters;
    final mode = params['mode'];
    final oobCode = params['oobCode'];

    if (mode == 'resetPassword' && (oobCode?.isNotEmpty ?? false)) {
      Get.to(() => CreateNewPasswordScreen(code: oobCode!));
    }
  }
}
