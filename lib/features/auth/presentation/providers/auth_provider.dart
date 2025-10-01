import 'package:flutter_riverpod/legacy.dart';
import 'package:spot/core/common/entities/user.dart';
import 'package:spot/core/common/log/app_logger.dart';
import 'package:spot/core/usecase/usecase.dart';
import 'package:spot/features/auth/domain/usecase/logout.dart';
import 'package:spot/features/auth/domain/usecase/user_login.dart';
import 'package:spot/features/auth/domain/usecase/user_signup.dart';
import 'package:spot/init_dependencies.dart';

sealed class AuthState {
  //constructor
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.success(User user) = AuthSucess;
  const factory AuthState.failure(String message) = AuthFailure;
}

//initial State
class AuthInitial extends AuthState {
  const AuthInitial();
}

//loading state
class AuthLoading extends AuthState {
  const AuthLoading();
}

//sucess-state
class AuthSucess extends AuthState {
  final User user;
  const AuthSucess(this.user);
}

//Failure-state
class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);
}

//notifier-class
class AuthNotifier extends StateNotifier<AuthState> {
  final UserSignup _userSignup;
  final UserLogin _userLogin;
  final Logout _userlogout;

  AuthNotifier(this._userSignup, this._userLogin, this._userlogout)
    : super(const AuthState.initial());

  Future<void> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    state = AuthState.loading();
    final result = await _userSignup(
      UserSignupParams(email: email, password: password, username: username),
    );
    result.fold(
      (failure) {
        AppLogger.e(failure.message ?? "");
        state = AuthState.failure(failure.message ?? "");
      },
      (user) {
        AppLogger.i(user.toString());
        state = AuthState.success(user);
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = AuthState.loading();
    final result = await _userLogin(UserLoginParams(email, password));
    result.fold(
      (failure) {
        AppLogger.e(failure.message ?? "");
        state = AuthState.failure(failure.message ?? "");
      },
      (user) {
        AppLogger.i(user.toString());
        state = AuthState.success(user);
      },
    );
  }

  Future<void> logout() async {
    final result = await _userlogout(Noparams());
    result.fold(
      (failure) {
        AppLogger.e(failure.message ?? "");
        state = AuthState.failure(failure.message ?? "");
      },
      (_) {
        state = const AuthState.initial();
      },
    );
  }
}

//notifier dependenicies

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    serviceLocater<UserSignup>(),
    serviceLocater<UserLogin>(),
    serviceLocater<Logout>(),
  );
});
