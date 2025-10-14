import 'package:flutter/material.dart';
import '../features/auth/login_signup_page.dart';
import '../features/home/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/global_providers.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    // Check if user already logged in
    final bool isLoggedIn = authService.currentUser != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: isLoggedIn ? const HomePage() : const LoginSignupPage(),
    );
  }
}
