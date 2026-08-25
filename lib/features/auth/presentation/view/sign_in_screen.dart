import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: const Center(
        child: Text(
          'Sign In',
          style: TextStyle(color: AppColors.primaryTextColor),
        ),
      ),
    );
  }
}
