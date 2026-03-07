import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_screen.dart';
import 'root_screen.dart';
import 'login_screen.dart';
import '../notifiers/auth_notifier.dart';

class AppStartScreen extends StatefulWidget {
  const AppStartScreen({super.key});

  @override
  State<AppStartScreen> createState() => _AppStartScreenState();
}

class _AppStartScreenState extends State<AppStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, authNotifier, child) {
        if (!authNotifier.isLoggedIn) {
          return const LoginScreen();
        }

        final email = authNotifier.email;
        if (email == null) {
          return const LoginScreen();
        }

        return _buildAfterLogin(email);
      },
    );
  }

  Widget _buildAfterLogin(String email) {
    return FutureBuilder<bool>(
      future: _checkIfOnboardingShown(email),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return const RootScreen();
        }

        return OnboardingScreen(
          onFinish: () async {
            final prefs = await SharedPreferences.getInstance();

            await prefs.setBool('onboarding_shown_$email', true);
            if (!mounted) return;
            setState(() {});
          },
        );
      },
    );
  }

  Future<bool> _checkIfOnboardingShown(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_shown_$email') ?? false;
  }
}