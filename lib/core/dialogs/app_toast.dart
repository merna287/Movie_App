import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

enum ToastType { success, error, info }

class AppToast {
  AppToast._();

  static OverlayEntry? _currentEntry;

  static void showToast(
    BuildContext context,
    String message, {
    ToastType type = ToastType.info,
  }) {
    final Color backgroundColor = switch (type) {
      ToastType.success => AppColors.successColor,
      ToastType.error => AppColors.errorColor,
      ToastType.info => AppColors.boxColor,
    };

    final OverlayState? overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    _removeCurrentEntry();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (dialogContext) => _ToastView(
        message: message,
        backgroundColor: backgroundColor,
        onDismissed: () => _removeCurrentEntry(entry),
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  static void _removeCurrentEntry([OverlayEntry? entry]) {
    final current = entry ?? _currentEntry;
    if (current == null) return;

    if (identical(_currentEntry, current)) {
      _currentEntry = null;
    }
    if (current.mounted) {
      current.remove();
    }
  }
}

class _ToastView extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final VoidCallback onDismissed;

  const _ToastView({
    required this.message,
    required this.backgroundColor,
    required this.onDismissed,
  });

  @override
  State<_ToastView> createState() => _ToastViewState();
}

class _ToastViewState extends State<_ToastView>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 250);
  static const Duration _displayDuration = Duration(seconds: 4);

  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duration);
    final curved =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(curved);

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(curved);

    _controller.forward();
    _timer = Timer(_displayDuration, _dismiss);
  }

  void _dismiss() {
    _controller.reverse().whenComplete(widget.onDismissed);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 12,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: widget.backgroundColor,
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: AppTypography.withColor(
                    AppTypography.montserrat14W500,
                    AppColors.primaryTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
