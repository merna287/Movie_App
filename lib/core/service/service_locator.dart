import 'package:get_it/get_it.dart';

import '../../features/auth/presentation/view_model/auth_view_model.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AuthViewModel>(() => AuthViewModel());
}
