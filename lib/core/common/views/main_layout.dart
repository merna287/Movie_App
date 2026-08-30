import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/common/widgets/custom_bottom_nav_ba.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Container(color: AppColors.successColor),
    Container(color: AppColors.grayColor),
    Container(color: AppColors.primaryTextColor),
    Container(color: AppColors.tertiaryTextColor),
    /*BlocProvider(create: (context) => getIt<HomeCubit>() , child: const HomeScreen()),
    BlocProvider(
    create: (context) => getIt<SearchCubit>(),
    child: SearchScreen(),
  ),
    WatchListScreen(),*/
  ];

  static const List<({String icon, String labelKey})> _navItems = [
    (icon: AppAssets.homeIcon, labelKey: LocaleKeys.home),
    (icon: AppAssets.searchIcon, labelKey: LocaleKeys.search),
    (icon: AppAssets.heartIcon, labelKey: LocaleKeys.favorite),
    (icon: AppAssets.personIcon, labelKey: LocaleKeys.profile),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70.h,
      color: AppColors.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_navItems.length, (index) {
          final item = _navItems[index];
          return CustomBottomNavBa(
            iconPath: item.icon,
            screenName: item.labelKey.tr(),
            isSelected: index == _currentIndex,
            onTap: () => setState(() => _currentIndex = index),
          );
        }),
      ),
    );
  }
}
