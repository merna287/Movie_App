import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/home/presentation/widgets/shimmer_box.dart';
import 'package:shimmer/shimmer.dart';

class HomeHeader extends StatefulWidget {
  final String userName;
  final String avatarUrl;

  const HomeHeader({super.key, this.userName = '', this.avatarUrl = ''});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  User? _user;
  bool _profileLoading = true;
  StreamSubscription<User?>? _userSubscription;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _userSubscription = FirebaseAuth.instance.userChanges().listen(
      _onUserChanged,
    );
    _syncProfile();
  }

  void _onUserChanged(User? user) {
    if (!mounted) return;

    final current = _user;
    final lostName =
        user != null &&
        (user.displayName == null || user.displayName!.trim().isEmpty);
    final hasResolvedName =
        current != null &&
        current.displayName != null &&
        current.displayName!.trim().isNotEmpty;

    // Ignore profile-stream events that arrive before the displayName write
    // has propagated; never regress an already-resolved username.
    if (lostName && hasResolvedName) return;

    setState(() {
      _user = user;
      if (user == null || !lostName) {
        _profileLoading = false;
      }
    });
  }

  Future<void> _syncProfile() async {
    final user = _user ?? FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _profileLoading = false);
      return;
    }

    try {
      await user.reload();

      var refreshed = FirebaseAuth.instance.currentUser ?? user;
      if (refreshed.displayName == null ||
          refreshed.displayName!.trim().isEmpty) {
        debugPrint(
          '[AUTH-TRACE] profile username empty after reload; retrying once',
        );
        try {
          await refreshed.reload();
          refreshed = FirebaseAuth.instance.currentUser ?? refreshed;
        } catch (_) {
          debugPrint('[AUTH-TRACE] profile reload retry failed');
        }
        debugPrint(
          '[AUTH-TRACE] profile username = '
          '"${refreshed.displayName ?? 'null'}"',
        );
      }

      if (!mounted) return;
      setState(() {
        _user = refreshed;
        _profileLoading = false;
      });
    } catch (_) {
      debugPrint('[AUTH-TRACE] profile reload failed; using cached user');
      if (mounted) setState(() => _profileLoading = false);
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  // Home is authenticated-only, so there is intentionally NO "Guest"
  // resolution. An empty string means the username has not been resolved yet
  // (loading), is genuinely missing on the account, or the user is not signed
  // in (unauthenticated). Callers decide the UI state, never a Guest label.
  String _resolveNameFor(User? user) {
    if (widget.userName.trim().isNotEmpty) return widget.userName.trim();
    if (user == null) return '';
    return user.displayName?.trim() ?? '';
  }

  String _avatarUrlFor(User? user) {
    if (widget.avatarUrl.isNotEmpty) return widget.avatarUrl;
    return user?.photoURL ?? '';
  }

  String _usernameLogLabel(String name) {
    if (_user == null) return '(unauthenticated - Home not accessible)';
    if (name.isNotEmpty) return name;
    return _profileLoading
        ? '(loading...)'
        : '(no username on account)';
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final name = _resolveNameFor(user);
    final avatar = _avatarUrlFor(user);

    debugPrint('[AUTH-TRACE] currentUser exists = ${user != null}');
    debugPrint('[AUTH-TRACE] uid = ${user?.uid ?? 'none'}');
    debugPrint('[AUTH-TRACE] email = ${user?.email ?? 'none'}');
    debugPrint(
      '[AUTH-TRACE] firebase displayName = ${user?.displayName ?? 'null'}',
    );
    debugPrint(
      '[AUTH-TRACE] stored username = '
      '${widget.userName.isNotEmpty ? widget.userName : (user?.displayName ?? 'null')}',
    );
    debugPrint('[AUTH-TRACE] home username = "${_usernameLogLabel(name)}"');

    // Never a "Guest" fallback: while the profile is unresolved (loading) or
    // no user is present (unauthenticated, being routed away) keep the
    // temporary shimmer UI defined below.
    final showNamePlaceholder =
        user == null || (name.isEmpty && _profileLoading);

    return Row(
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundColor: AppColors.boxColor,
          backgroundImage: avatar.isEmpty ? null : NetworkImage(avatar),
          child: avatar.isEmpty
              ? Icon(
                  Icons.person,
                  size: 24.w,
                  color: AppColors.tertiaryTextColor,
                )
              : null,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showNamePlaceholder)
                Shimmer.fromColors(
                  baseColor: AppColors.boxColor,
                  highlightColor: AppColors.headerButtonColor,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ShimmerBox(width: 140.w, height: 22.h),
                  ),
                )
              else
                Text(
                  LocaleKeys.helloName.tr(namedArgs: {'name': name}),
                  style: AppTypography.withColor(
                    AppTypography.montserrat18W600,
                    AppColors.primaryTextColor,
                  ),
                ),
              SizedBox(height: 4.h),
              Text(
                LocaleKeys.letsStreamYourFavoriteMovie.tr(),
                style: AppTypography.withColor(
                  AppTypography.montserrat12W500,
                  AppColors.tertiaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
