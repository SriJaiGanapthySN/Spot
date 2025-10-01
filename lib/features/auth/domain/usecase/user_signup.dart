import 'package:fpdart/fpdart.dart';
import 'package:spot/core/common/entities/user.dart';
import 'package:spot/core/error/failure.dart';
import 'package:spot/core/usecase/usecase.dart';
import 'package:spot/features/auth/domain/repo/auth_repo.dart';

class UserSignup implements Usecase<User, UserSignupParams> {
  final AuthRepo authRepo;
  const UserSignup(this.authRepo);
  @override
  Future<Either<Failure, User>> call(UserSignupParams params) async {
    return await authRepo.signUpWithEmailAndPassword(
      username: params.username,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignupParams {
  final String email;
  final String password;
  final String username;

  UserSignupParams({
    required this.email,
    required this.password,
    required this.username,
  });
}
