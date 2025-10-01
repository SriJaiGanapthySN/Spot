import 'package:firebase_auth/firebase_auth.dart';
import 'package:spot/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  });
  Future<UserModel> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  AuthRemoteDataSourceImpl(this._auth);
  @override
  Future<UserModel> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = response.user?.uid;
      if (uid != null && uid.isNotEmpty) {
        return UserModel(
          uid: uid,
          email: email,
          name: response.user?.displayName ?? "",
        );
      }
      throw FirebaseAuthException(code: 'NO_USER', message: 'No user Found');
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = response.user?.uid;
      if (uid != null && uid.isNotEmpty) {
        return UserModel(uid: uid, email: email, name: username);
      }
      throw FirebaseAuthException(code: 'NO_USER', message: 'User Not Created');
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }
}
