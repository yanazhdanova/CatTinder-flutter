import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDatasource {
  Future<void> register(String email, String password);
  Future<void> login(String email, String password);
  Future<(bool isLoggedIn, String? email)> checkAuthStatus();
  Future<void> logout();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences prefs;
  final FlutterSecureStorage secureStorage;

  AuthLocalDatasourceImpl({
    required this.prefs,
    required this.secureStorage,
  });

  static const _usersListKey = 'users_list';
  static const _currentUserKey = 'current_user';
  static const _isLoggedInKey = 'is_logged_in';

  @override
  Future<void> register(String email, String password) async {
    final usersList = _getUsersList();

    if (usersList.contains(email)) {
      throw Exception('Email уже зарегистрирован');
    }

    await secureStorage.write(
      key: 'user_$email',
      value: password,
    );


    usersList.add(email);
    await prefs.setStringList(_usersListKey, usersList);
  }

  @override
  Future<void> login(String email, String password) async {
    final savedPassword = await secureStorage.read(key: 'user_$email');

    if (savedPassword == null || savedPassword != password) {
      throw Exception('Email или пароль неверный');
    }


    await prefs.setString(_currentUserKey, email);
    await prefs.setBool(_isLoggedInKey, true);
  }

  @override
  Future<(bool isLoggedIn, String? email)> checkAuthStatus() async {
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    final email = prefs.getString(_currentUserKey);
    return (isLoggedIn, email);
  }

  @override
  Future<void> logout() async {
    await prefs.setBool(_isLoggedInKey, false);

  }


  List<String> _getUsersList() {
    return prefs.getStringList(_usersListKey) ?? [];
  }
}