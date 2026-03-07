import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<void> call(String email, String password) {
    return repository.register(email, password);
  }
}

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<void> call(String email, String password) {
    return repository.login(email, password);
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}

class GetAuthStatusUseCase {
  final AuthRepository repository;
  GetAuthStatusUseCase(this.repository);

  Future<(bool isLoggedIn, String? email)> call() {
    return repository.checkAuthStatus();
  }
}