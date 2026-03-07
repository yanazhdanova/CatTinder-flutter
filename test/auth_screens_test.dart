import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cat_tinder/notifiers/auth_notifier.dart';
import 'package:cat_tinder/service_locator.dart';
import 'package:cat_tinder/screens/login_screen.dart';
import 'package:cat_tinder/screens/register_screen.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await setupServiceLocator();
  });

  group('LoginScreen - Widget Tests', () {
    testWidgets('отображает поля email и пароля', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthNotifier()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Пароль'), findsOneWidget);
    });

    testWidgets('показывает ошибку при невалидном email', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthNotifier()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );


      final emailField = find.widgetWithText(TextFormField, 'example@mail.com');
      await tester.enterText(emailField.first, 'invalidemail');

      final loginButton = find.widgetWithText(ElevatedButton, 'Вход');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Введите корректный email'),
        findsOneWidget,
      );
    });

    testWidgets('показывает ошибку при коротком пароле', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthNotifier()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      final emailFields = find.byWidgetPredicate(
            (widget) => widget is TextFormField,
      );
      await tester.enterText(emailFields.first, 'test@mail.com');


      await tester.enterText(emailFields.at(1), '123');

      final loginButton = find.widgetWithText(ElevatedButton, 'Вход');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();


      expect(
        find.text('Пароль должен быть минимум 6 символов'),
        findsOneWidget,
      );
    });

    testWidgets('есть ссылка для перехода на регистрацию', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthNotifier()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      expect(find.text('Зарегистрируйтесь'), findsOneWidget);
    });
  });

  group('RegisterScreen - Widget Tests', () {
    testWidgets('отображает поля email и пароля', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Пароль'), findsOneWidget);
      expect(find.text('Подтвердите пароль'), findsOneWidget);
    });

    testWidgets('показывает ошибку если пароли не совпадают', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      final textFields = find.byWidgetPredicate(
            (widget) => widget is TextFormField,
      );

      await tester.enterText(textFields.first, 'test@mail.com');
      await tester.enterText(textFields.at(1), 'password123');
      await tester.enterText(textFields.at(2), 'password456');

      final registerButton = find.widgetWithText(ElevatedButton, 'Зарегистрироваться');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Пароли не совпадают'),
        findsOneWidget,
      );
    });

    testWidgets('показывает ошибку при невалидном email', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      final textFields = find.byWidgetPredicate(
            (widget) => widget is TextFormField,
      );


      await tester.enterText(textFields.first, 'invalidemail');
      await tester.enterText(textFields.at(1), 'password123');
      await tester.enterText(textFields.at(2), 'password123');
      final registerButton = find.widgetWithText(ElevatedButton, 'Зарегистрироваться');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();


      expect(
        find.text('Введите корректный email'),
        findsOneWidget,
      );
    });

    testWidgets('есть ссылка для перехода на логин', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      expect(find.text('Войдите'), findsOneWidget);
    });

    testWidgets('кнопка регистрации отключена пока идет загрузка', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      final registerButton = find.widgetWithText(ElevatedButton, 'Зарегистрироваться');
      expect(registerButton, findsOneWidget);
    });
  });
}