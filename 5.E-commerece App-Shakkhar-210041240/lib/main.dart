import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'features/auth/reset_password_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yhdqoroqfwthjfhdxbss.supabase.co', // your Project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InloZHFvcm9xZnd0aGpmaGR4YnNzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk3NDQwMjksImV4cCI6MjA3NTMyMDAyOX0.tNEnDWoNoG6CdFC88bWqcP7naxufNxNJd_bhdnjAsD8', // your actual anon key
  );

  // Check if the URL contains a Supabase recovery link
  final uri = Uri.base;
  final type = uri.queryParameters['type'];
  final accessToken = uri.queryParameters['access_token'];

  if (type == 'recovery' && accessToken != null) {
    // Navigate directly to ResetPasswordPage
    runApp(
      ProviderScope(
        child: ResetPasswordApp(accessToken: accessToken),
      ),
    );
  } else {
    // Normal login/signup flow
    runApp(const ProviderScope(child: MyApp()));
  }
}

/// Wrapper app for reset password flow
class ResetPasswordApp extends StatelessWidget {
  final String accessToken;
  const ResetPasswordApp({super.key, required this.accessToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghorer Bazar',
      theme: ThemeData(
        primaryColor: Colors.orange,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.orange,
          secondary: Colors.yellow,
        ),
      ),
      home: ResetPasswordPage(accessToken: accessToken),
    );
  }
}
