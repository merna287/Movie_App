import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/common/widgets/profile_avatar.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/ai/presentation/views/gemini_chat_screen.dart';
import 'package:movie_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:movie_app/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:movie_app/features/favorite/presentation/views/favorite_screen.dart';
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

  void _openAiChat() {
    Get.to(() => const GeminiChatScreen());
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
        ProfileAvatar(
          radius: 24.r,
          name: name,
          imageUrl: avatar,
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
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: _openAiChat,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              color: AppColors.headerButtonColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 20.w,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            final count = switch (state) {
              FavoriteLoaded(:final movies) => movies.length,
              FavoriteRemoving(:final movies) => movies.length,
              FavoriteToggling(:final movies) => movies.length,
              _ => 0,
            };
            final hasFavorites = count > 0;

            return GestureDetector(
              onTap: () => Get.to(() => const FavoriteScreen()),
              behavior: HitTestBehavior.opaque,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: const BoxDecoration(
                      color: AppColors.headerButtonColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        hasFavorites
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 20.w,
                        color: hasFavorites
                            ? AppColors.errorColor
                            : AppColors.grayColor,
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: -2.h,
                    end: -2.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.h,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18.w,
                        minHeight: 18.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE02F),
                        borderRadius: BorderRadius.circular(9.r),
                        border: Border.all(
                          color: AppColors.backgroundColor,
                          width: 1.5.w,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          style: TextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
