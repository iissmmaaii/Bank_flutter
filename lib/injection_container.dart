import 'package:bankapp3/core/network/http_headers_provider.dart';
import 'package:bankapp3/features/account/data/datasource/accountlocaldatasource.dart';
import 'package:bankapp3/features/account/data/datasource/accountremotedatasource.dart';
import 'package:bankapp3/features/account/data/repositories/accountrepositoryimp.dart';
import 'package:bankapp3/features/account/domain/account_repositry/account_repositry.dart';
import 'package:bankapp3/features/account/domain/usecases/change_email_usecase.dart';
import 'package:bankapp3/features/account/domain/usecases/change_name_usecase.dart';
import 'package:bankapp3/features/account/domain/usecases/change_numer_usecas.dart';
import 'package:bankapp3/features/account/domain/usecases/charge_another_account.dart';
import 'package:bankapp3/features/account/domain/usecases/getinfo_usecas.dart';
import 'package:bankapp3/features/account/presentation/bloc/accountuser_bloc.dart';
import 'package:bankapp3/features/alert/data/datasource/notification_local_datasource.dart';
import 'package:bankapp3/features/alert/data/datasource/paymentremotedatasource.dart';
import 'package:bankapp3/features/alert/data/repositories/notificationrepositoryImpl.dart';
import 'package:bankapp3/features/alert/data/repositories/paymentrepositoriesimpl.dart';
import 'package:bankapp3/features/alert/domain/repositories/notification_repositories.dart';
import 'package:bankapp3/features/alert/domain/repositories/paymentrepositories.dart';
import 'package:bankapp3/features/alert/domain/usecases/approvepaymentusecase.dart';
import 'package:bankapp3/features/alert/domain/usecases/getnotificationusecase.dart';
import 'package:bankapp3/features/alert/domain/usecases/rejectpaymentusecase.dart';
import 'package:bankapp3/features/alert/domain/usecases/savenotificationusecase.dart';
import 'package:bankapp3/features/alert/domain/usecases/updatenotificationusecase.dart';
import 'package:bankapp3/features/alert/presentation/bloc/alert_bloc.dart';
import 'package:bankapp3/features/alert/presentation/bloc/bloc/notification_bloc.dart';
import 'package:bankapp3/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:bankapp3/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bankapp3/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bankapp3/features/auth/domain/repositories/auth_repositry.dart';
import 'package:bankapp3/features/auth/domain/usecases/login_start_usecase.dart';
import 'package:bankapp3/features/auth/domain/usecases/login_finish_usecase.dart';
import 'package:bankapp3/features/auth/domain/usecases/signup_usecase.dart';
import 'package:bankapp3/features/auth/presentation/bloc/bloc/login_bloc.dart';
import 'package:bankapp3/features/auth/presentation/bloc/signin/signup_bloc.dart';
import 'package:bankapp3/core/error/network/network_info.dart';
import 'package:bankapp3/features/twofactorauthfeature/data/datasource/authenticator_remote_data_source.dart';
import 'package:bankapp3/features/twofactorauthfeature/data/reposittories/authenticatorrepositryimpl.dart';
import 'package:bankapp3/features/twofactorauthfeature/domain/repositres/authenticatorrepository.dart';
import 'package:bankapp3/features/twofactorauthfeature/domain/usecase/getsecretusecase.dart';
import 'package:bankapp3/features/twofactorauthfeature/domain/usecase/verifyotpusecase.dart';
import 'package:bankapp3/features/twofactorauthfeature/presentation/bloc/twofactorauthfeature_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  sl.registerLazySingleton(() => FlutterSecureStorage());
  sl.registerLazySingleton(() => LocalAuthentication());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Auth Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl(), sl()),
  );

  // Auth Use Cases
  sl.registerLazySingleton(() => LoginStartUseCase(sl()));
  sl.registerLazySingleton(() => LoginFinishUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton<HttpHeadersProvider>(
    () => HttpHeadersProvider(authLocalDataSource: sl()),
  );

  // Auth Blocs
  sl.registerFactory(
    () => LoginBloc(
      loginStartUseCase: sl(),
      loginFinishUseCase: sl(),
      localAuth: sl(),
      secureStorage: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerFactory(
    () => SignupBloc(
      signupUseCase: sl(),
      localAuth: sl(),
      secureStorage: sl(),
      localDataSource: sl(),
    ),
  );

  // Account Data Sources
  sl.registerLazySingleton<Accountlocaldatasource>(
    () => Accountlocaldatasource(storage: sl()),
  );
  sl.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSource(client: sl(), headersProvider: sl()),
  );

  // Account Repository
  sl.registerLazySingleton<AccountRepositry>(
    () => Accountrepositoryimp(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Account UseCases
  sl.registerLazySingleton(() => ChangeEmail(accountRepositry: sl()));
  sl.registerLazySingleton(() => ChangeName(accountRepositry: sl()));
  sl.registerLazySingleton(() => ChangeNumber(accountRepositry: sl()));
  sl.registerLazySingleton(() => ChargeAnotherAcoount(accountRepositry: sl()));
  sl.registerLazySingleton(() => GetInfo(accountRepositry: sl()));

  // Account Bloc
  sl.registerFactory(() => AccountuserBloc(sl(), sl(), sl(), sl(), sl(), sl()));

  // Alert Bloc
  sl.registerFactory(() => AlertBloc(sl(), sl()));

  // Payment Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<Paymetremotedatasource>(
    () => Paymetremotedatasource(client: sl(), headersProvider: sl()),
  );

  // Payment UseCases
  sl.registerLazySingleton(
    () => Approvepaymentusecase(paymentRepository: sl()),
  );
  sl.registerLazySingleton(() => RejectPayment(sl()));

  // Notification Local Data Source
  sl.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl.instance,
  );

  // Notification Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(localDataSource: sl()),
  );

  // Notification UseCases
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => SaveNotificationUseCase(sl()));
  sl.registerLazySingleton(() => UpdateNotificationStatusUseCase(sl()));

  // Notification Bloc
  sl.registerLazySingleton(() => NotificationBloc(sl(), sl(), sl()));

  // Two Factor Auth Data Source
  sl.registerLazySingleton<AuthenticatorRemoteDataSource>(
    () =>
        AuthenticatorRemoteDataSourceImpl(client: sl(), headersProvider: sl()),
  );

  // Two Factor Auth Repository
  sl.registerLazySingleton<AuthenticatorRepository>(
    () => AuthenticatorRepositoryImpl(remoteDataSource: sl()),
  );

  // Two Factor Auth Use Cases
  sl.registerLazySingleton(() => Getsecretusecase(repository: sl()));
  sl.registerLazySingleton(() => VerifyOtpUsecase(repository: sl()));

  // Two Factor Auth Bloc
  sl.registerFactory(
    () => TwofactorauthfeatureBloc(
      getSecretUsecase: sl(),
      verifyOtpUsecase: sl(),
      localAuth: sl(),
      localDataSource: sl(),
    ),
  );
}
