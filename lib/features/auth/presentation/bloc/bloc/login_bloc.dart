import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:bankapp3/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:bankapp3/features/auth/domain/entities/auth_response.dart';
import 'package:bankapp3/features/auth/domain/usecases/login_start_usecase.dart';
import 'package:bankapp3/features/auth/domain/usecases/login_finish_usecase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/signers/rsa_signer.dart';
import 'package:pointycastle/asymmetric/api.dart' show RSAPrivateKey;
import 'package:asn1lib/asn1lib.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/api.dart' show PrivateKeyParameter;

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginStartUseCase loginStartUseCase;
  final LoginFinishUseCase loginFinishUseCase;
  final LocalAuthentication localAuth;
  final FlutterSecureStorage secureStorage;
  final AuthLocalDataSource localDataSource;

  LoginBloc({
    required this.loginStartUseCase,
    required this.loginFinishUseCase,
    required this.localAuth,
    required this.secureStorage,
    required this.localDataSource,
  }) : super(LoginInitial()) {
    on<AutoLoginRequested>(_onAutoLoginRequested);
    on<LoginCompleted>(_onLoginCompleted);
  }

  Future<void> _onAutoLoginRequested(
    AutoLoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final userId = await localDataSource.getUserId();
      if (userId == null) {
        emit(LoginError('لم يتم العثور على مستخدم مسجل'));
        return;
      }

      final bool canAuthenticate = await localAuth.canCheckBiometrics;
      if (!canAuthenticate) {
        emit(LoginError('المصادقة البيومترية غير متوفرة'));
        return;
      }

      final result = await loginStartUseCase.execute(userId: userId);
      emit(
        result.fold(
          (error) => LoginError(error),
          (challenge) =>
              LoginBiometricPrompt(challenge: challenge, userId: userId),
        ),
      );
    } catch (e) {
      emit(LoginError('حدث خطأ: $e'));
    }
  }

  Future<void> _onLoginCompleted(
    LoginCompleted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final bool authenticated = await localAuth.authenticate(
        localizedReason: 'قم بالمصادقة لتسجيل الدخول',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (!authenticated) {
        emit(LoginError('فشلت المصادقة البيومترية'));
        return;
      }

      final privateKeyString = await localDataSource.getPrivateKey(
        event.userId,
      );
      if (privateKeyString == null) {
        emit(LoginError('لم يتم العثور على المفتاح الخاص'));
        return;
      }

      final privateKey = _parsePrivateKeyFromPem(privateKeyString);

      // Use the challenge as a plain string (Base64 URL-safe format without padding)
      String challengeString = event.challenge;
      // Remove padding (=) to match Backend's format
      challengeString = challengeString.replaceAll('=', '');

      // Debug: Print the challenge to verify its format
      debugPrint('Challenge to sign (without padding): $challengeString');

      // Sign the challenge as a plain UTF-8 string
      final challengeBytes = utf8.encode(challengeString);

      // Debug: Print the encoded challenge bytes
      debugPrint(
        'Encoded Challenge Bytes (UTF-8): ${challengeBytes.toString()}',
      );

      // Sign challenge
      final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
      signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));
      final signature = signer.generateSignature(challengeBytes).bytes;
      final signatureBase64 = base64Encode(signature);

      // Debug: Print the signature to verify
      debugPrint('Generated Signature: $signatureBase64');

      final result = await loginFinishUseCase.execute(
        userId: event.userId,
        signature: signatureBase64,
        deviceToken: event.deviceToken ?? '',
      );

      emit(
        result.fold((error) => LoginError(error), (authResponse) {
          localDataSource.cacheToken(authResponse.token);
          return LoginSuccess(authResponse: authResponse);
        }),
      );
    } catch (e, stacktrace) {
      debugPrint('❌ Exception: $e');
      debugPrint('📚 StackTrace: $stacktrace');
      emit(LoginError('حدث خطأ أثناء تسجيل الدخول: $e'));
    }
  }

  RSAPrivateKey _parsePrivateKeyFromPem(String pemString) {
    try {
      if (pemString.isEmpty ||
          !pemString.contains('-----BEGIN RSA PRIVATE KEY-----')) {
        debugPrint('🔐 المفتاح المستلم غير صالح: $pemString');
        throw FormatException('المفتاح الخاص غير صالح أو فارغ');
      }

      final lines =
          pemString
              .split('\n')
              .where(
                (line) =>
                    !line.startsWith('-----BEGIN') &&
                    !line.startsWith('-----END') &&
                    line.trim().isNotEmpty,
              )
              .toList();

      final base64 = lines.join('').trim();
      if (base64.isEmpty || !RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(base64)) {
        debugPrint('🔐 سلسلة Base64 غير صالحة: $base64');
        throw FormatException('سلسلة Base64 غير صالحة: $base64');
      }

      final decodedBytes = base64Decode(base64);
      final asn1Parser = ASN1Parser(decodedBytes);

      final topLevel = asn1Parser.nextObject();
      if (topLevel is! ASN1Sequence) {
        debugPrint('🔐 المفتاح ليس بصيغة ASN1Sequence: $topLevel');
        throw FormatException('المفتاح الخاص ليس بصيغة ASN1Sequence');
      }

      final topLevelSeq = topLevel as ASN1Sequence;
      ASN1Sequence privateKeySeq;

      if (topLevelSeq.elements.length > 1 &&
          topLevelSeq.elements[1] is ASN1Sequence) {
        privateKeySeq = topLevelSeq.elements[1] as ASN1Sequence;
      } else if (topLevelSeq.elements[0] is ASN1Integer) {
        privateKeySeq = topLevelSeq;
      } else {
        debugPrint('🔐 بنية المفتاح الخاص غير معترف بها: $topLevelSeq');
        throw FormatException('لم يتم التعرف على بنية المفتاح الخاص');
      }

      final modulus = privateKeySeq.elements[1] as ASN1Integer;
      final privateExponent = privateKeySeq.elements[3] as ASN1Integer;
      final p = privateKeySeq.elements[4] as ASN1Integer;
      final q = privateKeySeq.elements[5] as ASN1Integer;

      return RSAPrivateKey(
        modulus.valueAsBigInteger,
        privateExponent.valueAsBigInteger,
        p.valueAsBigInteger,
        q.valueAsBigInteger,
      );
    } catch (e) {
      debugPrint('🔐 خطأ أثناء تحليل المفتاح الخاص: $e');
      debugPrint('🔐 المفتاح المستلم: $pemString');
      throw FormatException('حدث خطأ أثناء تحليل المفتاح الخاص: $e');
    }
  }
}
