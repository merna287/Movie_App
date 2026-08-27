import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/features/auth/presentation/get_started/cubit/get_started_cubit.dart';
import 'package:movie_app/features/auth/presentation/get_started/cubit/get_started_state.dart';
import 'package:movie_app/features/auth/presentation/get_started/widgets/social_icon_button.dart';

enum _SocialProvider { google, facebook }

class SocialLoginButtons extends StatefulWidget {
  const SocialLoginButtons({super.key});

  @override
  State<SocialLoginButtons> createState() => _SocialLoginButtonsState();
}

class _SocialLoginButtonsState extends State<SocialLoginButtons> {
  _SocialProvider? _loadingProvider;

  void _signIn(_SocialProvider provider) {
    if (_loadingProvider != null) return;

    setState(() {
      _loadingProvider = provider;
    });

    final cubit = context.read<GetStartedCubit>();

    if (provider == _SocialProvider.google) {
      cubit.signInWithGoogle();
    } else {
      cubit.signInWithFacebook();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetStartedCubit, GetStartedState>(
      listener: (context, state) {
        if (state is GetStartedSuccess) {
          setState(() {
            _loadingProvider = null;
          });

          debugPrint('Social Sign-In successful');
          debugPrint('Name: ${state.user.displayName}');
          debugPrint('Email: ${state.user.email}');
          debugPrint('UID: ${state.user.uid}');
        } else if (state is GetStartedError) {
          setState(() {
            _loadingProvider = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialIconButton(
              asset: AppAssets.googleIcon,
              isLoading: _loadingProvider == _SocialProvider.google,
              onTap: () => _signIn(_SocialProvider.google),
            ),
            SizedBox(width: 45.w),
            SocialIconButton(
              asset: AppAssets.facebookIcon,
              isLoading: _loadingProvider == _SocialProvider.facebook,
              onTap: () => _signIn(_SocialProvider.facebook),
            ),
          ],
        );
      },
    );
  }
}