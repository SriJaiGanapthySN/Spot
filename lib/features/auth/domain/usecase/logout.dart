import 'package:fpdart/fpdart.dart';
import 'package:spot/core/error/failure.dart';
import 'package:spot/core/usecase/usecase.dart';
import 'package:spot/features/auth/domain/repo/auth_repo.dart';

class Logout implements Usecase<void, Noparams> {
  final AuthRepo _authRepo;
  Logout(this._authRepo);

  @override
  Future<Either<Failure, void>> call(Noparams params) async {
    return await _authRepo.logout();
  }
}
