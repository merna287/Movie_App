import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movie_app/features/home/presentation/cubit/home_state.dart';
import 'package:movie_app/features/home/presentation/widgets/featured_movie_card.dart';

class FeaturedMovieCarousel extends StatelessWidget {
  const FeaturedMovieCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return switch (state) {
          HomeInitial() || HomeLoading() => const _CarouselLoading(),
          HomeError(:final message) => _CarouselError(message: message),
          HomeSuccess(:final movies) =>
            movies.isEmpty
                ? const _CarouselEmpty()
                : _CarouselView(movies: movies),
        };
      },
    );
  }
}

class _CarouselLoading extends StatelessWidget {
  const _CarouselLoading();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 154.h,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      ),
    );
  }
}

class _CarouselError extends StatelessWidget {
  final String message;

  const _CarouselError({required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 154.h,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () => context.read<HomeCubit>().loadFeaturedMovies(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarouselEmpty extends StatelessWidget {
  const _CarouselEmpty();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 154.h,
      child: Center(
        child: Text(
          'No movies available',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _CarouselView extends StatefulWidget {
  final List<Movie> movies;

  const _CarouselView({required this.movies});

  @override
  State<_CarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends State<_CarouselView> {
  static const double _cardWidth = 295;
  static const double _slideGap = 12;
  static const double _screenWidth = 375;
  static const int _maxDots = 5;

  late int _itemCount;
  late PageController _pageController;
  Timer? _autoPlayTimer;
  late int _currentPage;
  late bool _forward;

  int get _movieIndex => _currentPage;

  @override
  void initState() {
    super.initState();
    _itemCount = widget.movies.length;
    _currentPage = 0;
    _forward = true;
    _pageController = PageController(
      viewportFraction: (_cardWidth + _slideGap) / _screenWidth,
    );
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(covariant _CarouselView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movies.length != widget.movies.length) {
      _itemCount = widget.movies.length;
      _currentPage = 0;
      _forward = true;
      _pageController.dispose();
      _pageController = PageController(
        viewportFraction: (_cardWidth + _slideGap) / _screenWidth,
      );
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  int _nextPage() {
    if (_forward) {
      if (_currentPage == _itemCount - 1) {
        _forward = false;
        return _currentPage - 1;
      }
      return _currentPage + 1;
    }
    if (_currentPage == 0) {
      _forward = true;
      return _currentPage + 1;
    }
    return _currentPage - 1;
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (_itemCount < 2) return;
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) return;
      _pageController.animateToPage(
        _nextPage(),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final dotCount = _itemCount < 2
        ? 0
        : (_itemCount < _maxDots ? _itemCount : _maxDots);

    return Column(
      children: [
        SizedBox(
          height: 154.h,
          child: PageView.builder(
            controller: _pageController,
            physics: const PageScrollPhysics(),
            itemCount: _itemCount,
            onPageChanged: (index) {
              setState(() {
                final delta = index - _currentPage;
                _currentPage = index;
                if (delta > 0) {
                  _forward = true;
                } else if (delta < 0) {
                  _forward = false;
                }
              });
              _startAutoPlay();
            },
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
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
        _DotIndicator(dotCount: dotCount, activeIndex: _movieIndex % _maxDots),
      ],
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int dotCount;
  final int activeIndex;

  const _DotIndicator({required this.dotCount, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    if (dotCount < 2) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotCount, (index) {
        final active = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          height: 8.h,
          width: active ? 24.w : 8.w,
          decoration: BoxDecoration(
            color: active
                ? AppColors.primaryColor
                : AppColors.primaryColor.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
