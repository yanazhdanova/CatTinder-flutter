import 'package:flutter/material.dart';
import '../service_locator.dart';
import '../domain/usecases/auth_usecases.dart';

class AuthNotifier extends ChangeNotifier {
  final RegisterUseCase _registerUseCase = getIt();
  final LoginUseCase _loginUseCase = getIt();
  final LogoutUseCase _logoutUseCase = getIt();
  final GetAuthStatusUseCase _getAuthStatusUseCase = getIt();

  bool _isLoggedIn = false;
  String? _email;
  String? _errorMessage;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  AuthNotifier() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final (isLoggedIn, email) = await _getAuthStatusUseCase.call();
      _isLoggedIn = isLoggedIn;
      _email = email;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoggedIn = false;
      _email = null;
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _registerUseCase.call(email, password);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _loginUseCase.call(email, password);
      _isLoggedIn = true;
      _email = email;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _logoutUseCase.call();
      _isLoggedIn = false;
      _email = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}