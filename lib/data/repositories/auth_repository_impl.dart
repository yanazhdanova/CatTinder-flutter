import '../data_sources/auth_local_datasource.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({required this.localDatasource});

  @override
  Future<(bool isLoggedIn, String? email)> checkAuthStatus() {
    return localDatasource.checkAuthStatus();
  }

  @override
  Future<void> register(String email, String password) {
    return localDatasource.register(email, password);
  }

  @override
  Future<void> login(String email, String password) {
    return localDatasource.login(email, password);
  }

  @override
  Future<void> logout() {
    return localDatasource.logout();
  }
}