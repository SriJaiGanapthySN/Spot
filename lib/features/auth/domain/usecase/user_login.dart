import 'package:fpdart/fpdart.dart';
import 'package:spot/core/common/entities/user.dart';
import 'package:spot/core/error/failure.dart';
import 'package:spot/core/usecase/usecase.dart';
import 'package:spot/features/auth/domain/repo/auth_repo.dart';

class UserLogin implements Usecase<User, UserLoginParams> {
  final AuthRepo _authRepo;
  UserLogin(this._authRepo);
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await _authRepo.logInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams(this.email, this.password);
}
