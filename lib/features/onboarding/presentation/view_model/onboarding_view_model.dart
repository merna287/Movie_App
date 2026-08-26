class OnboardingViewModel {
  bool _isFirstTime = true;

  bool get isFirstTime => _isFirstTime;

  void setFirstTimeDone() {
    _isFirstTime = false;
  }
}
