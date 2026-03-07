import '../entities/user.dart';

abstract class AuthRepository {
  Future<(bool isLoggedIn, String? email)> checkAuthStatus();
  Future<void> register(String email, String password);
  Future<void> login(String email, String password);
  Future<void> logout();
}