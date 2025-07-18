import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:asn1lib/asn1lib.dart';
import 'package:bloc/bloc.dart';
import 'package:bankapp3/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:bankapp3/features/auth/domain/entities/user.dart';
import 'package:bankapp3/features/auth/domain/usecases/signup_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase signupUseCase;
  final LocalAuthentication localAuth;
  final FlutterSecureStorage secureStorage;
  final AuthLocalDataSource localDataSource;

  SignupBloc({
    required this.signupUseCase,
    required this.localAuth,
    required this.secureStorage,
    required this.localDataSource,
  }) : super(SignupInitial()) {
    on<SignupWithPasskeySubmitted>(_onSignupWithPasskeySubmitted);
  }

  // Helper: Convert BigInt to bytes
  List<int> bigIntToBytes(BigInt bigInt) {
    final hex = bigInt.toRadixString(16).padLeft(256, '0');
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      final end = (i + 2 <= hex.length) ? i + 2 : hex.length;
      bytes.add(int.parse(hex.substring(i, end), radix: 16));
    }
    return bytes;
  }

  // Helper: Chunk string
  List<String> _chunk(String str, int size) {
    final chunks = <String>[];
    for (var i = 0; i < str.length; i += size) {
      final end = (i + size <= str.length) ? i + size : str.length;
      chunks.add(str.substring(i, end));
    }
    return chunks;
  }

  // Encode private key to PEM (PKCS#1)
  String encodePrivateKeyToPemPKCS1(RSAPrivateKey privateKey) {
    final topLevel =
        ASN1Sequence()
          ..add(ASN1Integer(BigInt.zero)) // version
          ..add(ASN1Integer(privateKey.n!)) // modulus
          ..add(ASN1Integer(BigInt.parse('65537'))) // publicExponent (e)
          ..add(ASN1Integer(privateKey.exponent!)) // privateExponent (d)
          ..add(ASN1Integer(privateKey.p!))
          ..add(ASN1Integer(privateKey.q!))
          ..add(
            ASN1Integer(privateKey.exponent! % (privateKey.p! - BigInt.one)),
          )
          ..add(
            ASN1Integer(privateKey.exponent! % (privateKey.q! - BigInt.one)),
          )
          ..add(ASN1Integer(privateKey.q!.modInverse(privateKey.p!)));

    final bytes = topLevel.encodedBytes;
    final pem = base64Encode(bytes);
    final formattedPem = _chunk(pem, 64).join('\n');
    return '-----BEGIN RSA PRIVATE KEY-----\n$formattedPem\n-----END RSA PRIVATE KEY-----';
  }

  // Encode public key to PEM (SPKI format)
  String encodePublicKeyToPemPKCS1(RSAPublicKey publicKey) {
    final sequence =
        ASN1Sequence()
          ..add(ASN1Integer(publicKey.modulus!))
          ..add(ASN1Integer(publicKey.exponent!));
    final subjectPublicKeyInfo =
        ASN1Sequence()
          ..add(
            ASN1Sequence()
              ..add(
                ASN1ObjectIdentifier([1, 2, 840, 113549, 1, 1, 1]),
              ) // RSA OID
              ..add(ASN1Null()),
          )
          ..add(ASN1BitString(sequence.encodedBytes));
    final bytes = subjectPublicKeyInfo.encodedBytes;
    final pem = base64Encode(bytes);
    final formattedPem = _chunk(pem, 64).join('\n');
    return '-----BEGIN PUBLIC KEY-----\n$formattedPem\n-----END PUBLIC KEY-----';
  }

  // Main Signup Logic
  Future<void> _onSignupWithPasskeySubmitted(
    SignupWithPasskeySubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());

    try {
      final bool canAuthenticate = await localAuth.canCheckBiometrics;
      if (!canAuthenticate) {
        emit(SignupError('المصادقة البيومترية غير متوفرة'));
        return;
      }

      // طلب المصادقة البيومترية وينتظر النتيجة (await مهم جداً)
      final bool authenticated = await localAuth.authenticate(
        localizedReason: 'قم بالمصادقة للتسجيل باستخدام Passkey',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      // إذا المصادقة فشلت نرجع خطأ
      if (!authenticated) {
        emit(SignupError('فشلت المصادقة البيومترية'));
        return;
      }

      // Generate key pair
      final secureRandom = FortunaRandom();
      final seedSource = Random.secure();
      secureRandom.seed(
        KeyParameter(
          Uint8List.fromList(List.generate(32, (_) => seedSource.nextInt(256))),
        ),
      );

      final keyGen = RSAKeyGenerator();
      keyGen.init(
        ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
          secureRandom,
        ),
      );

      final keyPair = keyGen.generateKeyPair();
      final publicKey = keyPair.publicKey as RSAPublicKey;
      final privateKey = keyPair.privateKey as RSAPrivateKey;

      // Encode public key to PEM
      final publicKeyPem = encodePublicKeyToPemPKCS1(publicKey);

      // Encode private key
      final privateKeyPem = encodePrivateKeyToPemPKCS1(privateKey);

      // Validate key parsing
      try {
        final asn1Parser = ASN1Parser(
          base64Decode(
            privateKeyPem
                .replaceAll('-----BEGIN RSA PRIVATE KEY-----', '')
                .replaceAll('-----END RSA PRIVATE KEY-----', '')
                .replaceAll('\n', ''),
          ),
        );
        final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
        if (topLevelSeq.elements.length != 9) {
          emit(SignupError('خطأ في توليد المفتاح. الرجاء المحاولة مجددًا.'));
          return;
        }
      } catch (e) {
        emit(SignupError('تحليل المفتاح فشل قبل التخزين: $e'));
        return;
      }

      // Execute signup
      final result = await signupUseCase.execute(
        username: event.username,
        email: event.email,
        phoneNumber: event.phoneNumber,
        publicKey: publicKeyPem, // Send PEM instead of modulus
      );

      await result.fold(
        (error) async {
          emit(SignupError(error));
        },
        (user) async {
          await localDataSource.cachePrivateKey(privateKeyPem, user.id);
          await localDataSource.cacheUserInfo(user);
          emit(SignupSuccess(user));
        },
      );
    } catch (e) {
      emit(SignupError('حدث خطأ أثناء التسجيل: $e'));
    }
  }
}
