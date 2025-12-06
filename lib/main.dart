import 'package:flutter/material.dart';

import 'screens/root_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatTinder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFF7AA7),
          secondary: Color(0xFFFFD7E8),
        ),
      ),
      home: const RootScreen(),
    );
  }
}
