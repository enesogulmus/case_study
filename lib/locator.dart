import 'package:get_it/get_it.dart';

import 'core/api/api.dart';
import 'core/api/api_base_helper.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => ApiBaseHelper());
}
