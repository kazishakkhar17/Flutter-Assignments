import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';
import 'login_signup_page.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  final String accessToken;
  const ResetPasswordPage({super.key, required this.accessToken});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final passwordController = TextEditingController();

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> handleReset() async {
    final newPassword = passwordController.text.trim();
    if (newPassword.isEmpty) {
      showMessage('Password cannot be empty');
      return;
    }

    try {
      // ✅ Call updatePassword from AuthController
      await ref.read(authControllerProvider.notifier)
          .updatePassword(newPassword, widget.accessToken);

      showMessage('Password updated! You can login now.');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginSignupPage()),
      );
    } catch (e) {
      showMessage('Failed to reset password: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleReset,
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
