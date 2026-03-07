import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferences - Unit Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('сохраняет и читает список пользователей', () async {
      const usersList = ['user1@mail.com', 'user2@mail.com'];

      await prefs.setStringList('users_list', usersList);

      final saved = prefs.getStringList('users_list');
      expect(saved, equals(usersList));
    });

    test('сохраняет и читает статус авторизации', () async {
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('current_user', 'test@mail.com');

      final isLoggedIn = prefs.getBool('is_logged_in');
      final email = prefs.getString('current_user');

      expect(isLoggedIn, isTrue);
      expect(email, equals('test@mail.com'));
    });

    test('добавляет пользователя в список', () async {
      final usersList = prefs.getStringList('users_list') ?? [];
      usersList.add('user1@mail.com');
      await prefs.setStringList('users_list', usersList);

      final saved = prefs.getStringList('users_list') ?? [];
      expect(saved.length, equals(1));
      expect(saved, contains('user1@mail.com'));
    });

    test('проверяет есть ли пользователь в списке', () async {
      final usersList = ['user1@mail.com', 'user2@mail.com'];
      await prefs.setStringList('users_list', usersList);

      final saved = prefs.getStringList('users_list') ?? [];
      expect(saved.contains('user1@mail.com'), isTrue);
      expect(saved.contains('user3@mail.com'), isFalse);
    });

    test('удаляет статус при выходе', () async {
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('current_user', 'test@mail.com');

      await prefs.setBool('is_logged_in', false);
      await prefs.remove('current_user');

      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      final email = prefs.getString('current_user');

      expect(isLoggedIn, isFalse);
      expect(email, isNull);
    });

    test('сохраняет несколько пользователей', () async {
      final users = ['user1@mail.com', 'user2@mail.com', 'user3@mail.com'];
      await prefs.setStringList('users_list', users);

      final saved = prefs.getStringList('users_list') ?? [];
      expect(saved.length, equals(3));
    });

    test('разные пользователи имеют разные статусы', () async {
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('current_user', 'user1@mail.com');

      expect(prefs.getBool('is_logged_in'), isTrue);
      expect(prefs.getString('current_user'), equals('user1@mail.com'));

      await prefs.setBool('is_logged_in', false);

      await prefs.setBool('is_logged_in', true);
      await prefs.setString('current_user', 'user2@mail.com');

      expect(prefs.getBool('is_logged_in'), isTrue);
      expect(prefs.getString('current_user'), equals('user2@mail.com'));
    });
  });

  group('Email Validation - Unit Tests', () {
    bool isValidEmail(String email) {
      return email.contains('@') &&
          email.contains('.') &&
          email.indexOf('@') > 0 &&
          email.indexOf('.') > email.indexOf('@') + 1;
    }

    test('валидирует правильный email', () {
      expect(isValidEmail('test@mail.com'), isTrue);
      expect(isValidEmail('user@example.co'), isTrue);
    });

    test('отклоняет неправильный email', () {
      expect(isValidEmail('invalidemail'), isFalse);
      expect(isValidEmail('test@'), isFalse);
      expect(isValidEmail('@mail.com'), isFalse);
    });
  });

  group('Password Validation - Unit Tests', () {
    bool isValidPassword(String password) {
      return password.length >= 6;
    }

    test('валидирует пароль >= 6 символов', () {
      expect(isValidPassword('password123'), isTrue);
      expect(isValidPassword('123456'), isTrue);
    });

    test('отклоняет пароль < 6 символов', () {
      expect(isValidPassword('12345'), isFalse);
      expect(isValidPassword('abc'), isFalse);
    });
  });

  group('User List Management - Unit Tests', () {
    test('добавляет пользователя если его нет', () {
      List<String> users = [];
      const newUser = 'user1@mail.com';

      if (!users.contains(newUser)) {
        users.add(newUser);
      }

      expect(users, contains(newUser));
      expect(users.length, equals(1));
    });

    test('не добавляет дубликат пользователя', () {
      List<String> users = ['user1@mail.com'];
      const newUser = 'user1@mail.com';

      if (!users.contains(newUser)) {
        users.add(newUser);
      }

      expect(users.length, equals(1));
    });

    test('управляет списком нескольких пользователей', () {
      List<String> users = [];

      users.add('user1@mail.com');
      users.add('user2@mail.com');
      users.add('user3@mail.com');

      expect(users.length, equals(3));
      expect(users[0], equals('user1@mail.com'));
      expect(users[1], equals('user2@mail.com'));
      expect(users[2], equals('user3@mail.com'));
    });
  });
}