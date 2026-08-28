import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class AppDialogs {
  AppDialogs._();

  static BuildContext? _loadingContext;

  static Future<void> showLoadingDialog(BuildContext context) async {
    if (_loadingContext != null) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        _loadingContext = dialogContext;
        return const PopScope(
          canPop: false,
          child: _AppLoadingDialog(),
        );
      },
    ).whenComplete(() {
      _loadingContext = null;
    });
  }

  static void hideLoading() {
    final dialogContext = _loadingContext;
    if (dialogContext == null) return;

    _loadingContext = null;
    if (dialogContext.mounted) {
      Navigator.of(dialogContext, rootNavigator: true).pop();
    }
  }
}

class _AppLoadingDialog extends StatelessWidget {
  const _AppLoadingDialog();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryColor),
    );
  }
}
