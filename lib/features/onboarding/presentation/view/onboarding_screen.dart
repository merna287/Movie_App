import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/get_started/presentation/views/get_started_screen.dart';
import 'package:movie_app/features/onboarding/data/models/onboarding_item.dart';
import 'package:movie_app/features/onboarding/presentation/widgets/onboarding_controls.dart';
import 'package:movie_app/features/onboarding/presentation/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pageTransitionDuration = Duration(milliseconds: 350);

  late final PageController _pageController;
  late final List<OnboardingItem> _items;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _items = [
      OnboardingItem(
        image: AppAssets.onboarding1,
        title: LocaleKeys.onboardingTitle1.tr(),
        description: LocaleKeys.onboardingDescription1.tr(),
      ),
      OnboardingItem(
        image: AppAssets.onboarding2,
        title: LocaleKeys.onboardingTitle2.tr(),
        description: LocaleKeys.onboardingDescription2.tr(),
      ),
      OnboardingItem(
        image: AppAssets.onboarding3,
        title: LocaleKeys.onboardingTitle3.tr(),
        description: LocaleKeys.onboardingDescription3.tr(),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double get _progress => (_currentPage + 1) / _items.length;

  void _handleGetStarted() {
    Get.off(() => const GetStartedScreen());
  }

  void _onNextPressed() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: _pageTransitionDuration,
        curve: Curves.easeOutCubic,
      );
      return;
    }

    _handleGetStarted();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    item: _items[index],
                  );
                },
              ),
            ),
            SizedBox(height: 47.h),
            OnboardingControls(
              pageController: _pageController,
              itemCount: _items.length,
              progress: _progress,
              onNextPressed: _onNextPressed,
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}