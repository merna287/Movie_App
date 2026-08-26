import 'package:get_it/get_it.dart';
import 'package:movie_app/features/onboarding/presentation/view_model/onboarding_view_model.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<OnboardingViewModel>(() => OnboardingViewModel());
}
