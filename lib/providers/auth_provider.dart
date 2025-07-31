import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

final userInfoProvider = FutureProvider<Map<String, String>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'name': prefs.getString('user_name') ?? 'User',
    'email': prefs.getString('user_email') ?? '',
    'uid': prefs.getString('user_id') ?? '',
  };
});
class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;
  AuthNotifier(this._authService) : super(const AsyncValue.loading()) {
    _checkAuthState();
  }
  void _checkAuthState() {
    final user = _authService.currentUser;
    if (user != null) {
      state = AsyncValue.data(UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'User',
      ));
    } else {
      state = const AsyncValue.data(null);
    }
  }
  Future<void> signInWithEmailPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signInWithEmailPassword(email, password);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  Future<void> signUpWithEmailPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signUpWithEmailPassword(email, password);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  Future<void> signOut() async {
    await _authService.signOut();
    state = const AsyncValue.data(null);
  }
}

