//import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'data/data_sources/auth_local_datasource.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/auth_usecases.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();

  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);

  getIt.registerSingleton<AuthLocalDatasource>(
    AuthLocalDatasourceImpl(
      prefs: getIt(),
      secureStorage: getIt(),
    ),
  );

  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      localDatasource: getIt(),

    ),
  );


  getIt.registerSingleton<RegisterUseCase>(
    RegisterUseCase(getIt()),
  );

  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(getIt()),
  );

  getIt.registerSingleton<LogoutUseCase>(
    LogoutUseCase(getIt()),
  );

  getIt.registerSingleton<GetAuthStatusUseCase>(
    GetAuthStatusUseCase(getIt()),
  );
}
