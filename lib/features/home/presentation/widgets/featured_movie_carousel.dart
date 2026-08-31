import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/home/presentation/mock/home_mock_data.dart';
import 'package:movie_app/features/home/presentation/widgets/featured_movie_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FeaturedMovieCarousel extends StatefulWidget {
  final List<HomeMovie> featuredMovies;

  const FeaturedMovieCarousel({super.key, required this.featuredMovies});

  @override
  State<FeaturedMovieCarousel> createState() => _FeaturedMovieCarouselState();
}

class _FeaturedMovieCarouselState extends State<FeaturedMovieCarousel> {
  static const double _cardWidth = 295;
  static const double _slideGap = 12;
  static const double _screenWidth = 375;

  late final int _itemCount;
  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _itemCount = widget.featuredMovies.length;
    _currentPage = _itemCount * 1000;
    _pageController = PageController(
      viewportFraction: (_cardWidth + _slideGap) / _screenWidth,
      initialPage: _currentPage,
    );
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      final next = _currentPage + 1;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 154.h,
          child: PageView.builder(
            controller: _pageController,
            physics: const PageScrollPhysics(),
            onPageChanged: (index) {
              _currentPage = index;
              _startAutoPlay();
            },
            itemBuilder: (context, index) {
              final movie = widget.featuredMovies[index % _itemCount];
              return Center(
                child: SizedBox(
                  width: _cardWidth.w,
                  height: 154.h,
                  child: FeaturedMovieCard(movie: movie),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        SmoothPageIndicator(
          controller: _pageController,
          count: _itemCount,
          effect: ExpandingDotsEffect(
            dotHeight: 8.h,
            dotWidth: 8.w,
            expansionFactor: 3,
            spacing: 6.w,
            activeDotColor: AppColors.primaryColor,
            dotColor: AppColors.primaryColor.withValues(alpha: 0.25),
          ),
        ),
      ],
    );
  }
}
