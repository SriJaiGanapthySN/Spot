import 'package:fpdart/fpdart.dart';
import 'package:spot/core/common/entities/user.dart';
import 'package:spot/core/error/failure.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> logInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> logout();
}
