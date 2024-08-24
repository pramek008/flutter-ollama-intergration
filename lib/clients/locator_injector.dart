import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../services/secure_storage.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Register FlutterSecureStorage as a singleton
  locator.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());

  // Register SecureStorage (the abstract class) with SecureStorageImpl as the implementation
  locator.registerLazySingleton<SecureStorageImpl>(
      () => SecureStorageImpl(locator<FlutterSecureStorage>()));
}
