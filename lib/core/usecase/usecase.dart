import 'package:fpdart/fpdart.dart';
import 'package:spot/core/error/failure.dart';

abstract interface class Usecase<SucessType, Params> {
  Future<Either<Failure, SucessType>> call(Params params);
}

class Noparams {}
