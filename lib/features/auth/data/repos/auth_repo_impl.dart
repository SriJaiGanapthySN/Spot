import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fpdart/fpdart.dart';
import 'package:spot/core/error/failure.dart';
import 'package:spot/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:spot/features/auth/domain/repo/auth_repo.dart';
import 'package:spot/core/common/entities/user.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource repoDataSource;
  AuthRepoImpl(this.repoDataSource);
  @override
  Future<Either<Failure, User>> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await repoDataSource.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final user = await repoDataSource.signUpWithEmailAndPassword(
        username: username,
        email: email,
        password: password,
      );
      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await repoDataSource.logout();
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message));
    }
  }
}
