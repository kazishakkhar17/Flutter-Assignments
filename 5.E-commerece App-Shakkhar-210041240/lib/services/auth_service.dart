import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  // Send reset password email
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      print('Password reset email sent to $email');
    } catch (e) {
      print('Password reset error: $e');
      rethrow;
    }
  }

  // Update password using recovery link token
  Future<void> updatePassword(String newPassword, String accessToken) async {
    try {
      // Recover the session from the access token
      await _client.auth.recoverSession(accessToken);

      // Update the password for the recovered session
      await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      print('Password updated successfully');
    } catch (e) {
      print('Update password error: $e');
      rethrow;
    }
  }
}
