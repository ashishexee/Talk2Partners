import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<UserModel?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        String displayName = user.displayName ?? email.split('@')[0];
        await _saveUserToPreferences(user.uid, user.email ?? '', displayName);

        return UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: displayName,
        );
      }
    } catch (e) {
      debugPrint('Error signing in: $e');
      rethrow;
    }
    return null;
  }

  Future<UserModel?> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        String displayName = email.split('@')[0];

        await user.updateDisplayName(displayName);

        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        await _saveUserToPreferences(user.uid, user.email ?? '', displayName);

        return UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: displayName,
        );
      }
    } catch (e) {
      debugPrint('Error signing up: $e');
      rethrow;
    }
    return null;
  }

  Future<void> _saveUserToPreferences(
    String uid,
    String email,
    String name,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    debugPrint(
      'Saving user to preferences: uid=$uid, email=$email, name=$name',
    );

    await prefs.setString('user_id', uid);
    await prefs.setString('user_email', email);
    await prefs.setString('user_name', name);
  }

  Future<void> signOut() async {
    print('Signing out user: ${_auth.currentUser?.uid}');
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('User signed out, current user: ${_auth.currentUser?.uid ?? 'null'}');
  }
}
