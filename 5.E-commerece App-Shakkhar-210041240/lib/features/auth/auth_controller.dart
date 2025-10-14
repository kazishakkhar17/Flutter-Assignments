import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_ghorerbazar/services/auth_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../providers/global_providers.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthController(service);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthService _service;

  AuthController(this._service) : super(const AsyncData(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      final res = await _service.signIn(email, password);
      if (res.user == null) throw Exception('Invalid email or password');
      state = const AsyncData(null);
    } catch (e, st) {
      print('SignIn failed: $e');
      print(st);
      state = AsyncError(e, st);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    try {
      final res = await _service.signUp(email, password);
      if (res.user == null) throw Exception('Failed to create account');
      state = const AsyncData(null);
    } catch (e, st) {
      print('SignUp failed: $e');
      print(st);
      state = AsyncError(e, st);
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    try {
      await _service.resetPassword(email);
      state = const AsyncData(null);
    } catch (e, st) {
      print('Reset password failed: $e');
      state = AsyncError(e, st);
    }
  }

  // ✅ NEW METHOD for ResetPasswordPage
  Future<void> updatePassword(String newPassword, String accessToken) async {
    state = const AsyncLoading();
    try {
      await _service.updatePassword(newPassword, accessToken);
      state = const AsyncData(null);
    } catch (e, st) {
      print('Update password failed: $e');
      state = AsyncError(e, st);
    }
  }
}
