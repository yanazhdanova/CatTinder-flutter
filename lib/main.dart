import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'service_locator.dart';
import 'notifiers/auth_notifier.dart';
import 'screens/app_start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthNotifier(),
        ),
      ],
      child: MaterialApp(
        title: 'CatTinder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF7AA7),
          ).copyWith(
            primary: const Color(0xFFFF7AA7),
            secondary: const Color(0xFFFFD7E8),
          ),
        ),
        home: const AppStartScreen(),
      ),
    );
  }
}