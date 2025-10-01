import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:spot/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:spot/features/auth/data/repos/auth_repo_impl.dart';
import 'package:spot/features/auth/domain/repo/auth_repo.dart';
import 'package:spot/features/auth/domain/usecase/logout.dart';
import 'package:spot/features/auth/domain/usecase/user_login.dart';
import 'package:spot/features/auth/domain/usecase/user_signup.dart';
import 'package:spot/firebase_options.dart';

final serviceLocater = GetIt.instance;

Future<void> initDependencies() async {
  final firebase = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  serviceLocater.registerSingleton(() => firebase);
  serviceLocater.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );
  _initauth();
}

void _initauth() {
  //datasouce dependencies
  serviceLocater.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocater()),
  );

  //usercase dependencies
  serviceLocater.registerFactory<AuthRepo>(
    () => AuthRepoImpl(serviceLocater()),
  );
  serviceLocater.registerFactory<UserSignup>(
    () => UserSignup(serviceLocater()),
  );
  serviceLocater.registerFactory<UserLogin>(() => UserLogin(serviceLocater()));
  serviceLocater.registerFactory<Logout>(() => Logout(serviceLocater()));
}
