import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthDatasource {
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String fullName);
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Future<void> resetPassword(String email);
  Future<User?> updateProfile(
      {String? fullName, String? email, String? password});
  Stream<AuthState> getAuthStateChanges();
}
