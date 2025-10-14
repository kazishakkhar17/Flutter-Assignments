import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';
import '../home/home_page.dart';

class LoginSignupPage extends ConsumerStatefulWidget {
  const LoginSignupPage({super.key});

  @override
  ConsumerState<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends ConsumerState<LoginSignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoginMode = true;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> handleAuth() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('Email and password cannot be empty');
      return;
    }

    final controller = ref.read(authControllerProvider.notifier);

    try {
      if (isLoginMode) {
        await controller.signIn(email, password);
      } else {
        await controller.signUp(email, password);
      }

      final state = ref.read(authControllerProvider);
      if (state is AsyncData) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      } else if (state is AsyncError) {
        showMessage(state.error.toString());
      }
    } catch (e) {
      showMessage(e.toString());
    }
  }

  Future<void> handleForgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showMessage('Enter your email to reset password');
      return;
    }

    final controller = ref.read(authControllerProvider.notifier);
    try {
      await controller.resetPassword(email);
      showMessage('Password reset email sent!');
    } catch (e) {
      showMessage('Failed to send reset email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isLoginMode ? 'Login' : 'Sign Up'),
        backgroundColor: Colors.orange, // App theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            if (isLoginMode)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: handleForgotPassword,
                  child: const Text('Forgot Password?'),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: state.isLoading ? null : handleAuth,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              child: state.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(isLoginMode ? 'Sign In' : 'Create Account'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() => isLoginMode = !isLoginMode);
              },
              child: Text(
                isLoginMode
                    ? 'Don\'t have an account? Sign Up'
                    : 'Already have an account? Login',
                style: const TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
