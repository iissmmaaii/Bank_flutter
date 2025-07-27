import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:bankapp3/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:bankapp3/features/twofactorauthfeature/domain/usecase/getsecretusecase.dart';
import 'package:bankapp3/features/twofactorauthfeature/domain/usecase/verifyotpusecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bankapp3/features/twofactorauthfeature/domain/entities/authenticatorsecret.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';

part 'twofactorauthfeature_event.dart';
part 'twofactorauthfeature_state.dart';

class TwofactorauthfeatureBloc
    extends Bloc<TwofactorauthfeatureEvent, TwofactorauthfeatureState> {
  final Getsecretusecase getSecretUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final LocalAuthentication localAuth;
  final AuthLocalDataSource localDataSource;
  List<int> bigIntToBytes(BigInt bigInt) {
    final hex = bigInt.toRadixString(16).padLeft(256, '0');
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      final end = (i + 2 <= hex.length) ? i + 2 : hex.length;
      bytes.add(int.parse(hex.substring(i, end), radix: 16));
    }
    return bytes;
  }

  List<String> _chunk(String str, int size) {
    final chunks = <String>[];
    for (var i = 0; i < str.length; i += size) {
      final end = (i + size <= str.length) ? i + size : str.length;
      chunks.add(str.substring(i, end));
    }
    return chunks;
  }

  String encodePrivateKeyToPemPKCS1(RSAPrivateKey privateKey) {
    final topLevel =
        ASN1Sequence()
          ..add(ASN1Integer(BigInt.zero))
          ..add(ASN1Integer(privateKey.n!))
          ..add(ASN1Integer(BigInt.parse('65537')))
          ..add(ASN1Integer(privateKey.exponent!))
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

  String encodePublicKeyToPemPKCS1(RSAPublicKey publicKey) {
    final sequence =
        ASN1Sequence()
          ..add(ASN1Integer(publicKey.modulus!))
          ..add(ASN1Integer(publicKey.exponent!));
    final subjectPublicKeyInfo =
        ASN1Sequence()
          ..add(
            ASN1Sequence()
              ..add(ASN1ObjectIdentifier([1, 2, 840, 113549, 1, 1, 1]))
              ..add(ASN1Null()),
          )
          ..add(ASN1BitString(sequence.encodedBytes));
    final bytes = subjectPublicKeyInfo.encodedBytes;
    final pem = base64Encode(bytes);
    final formattedPem = _chunk(pem, 64).join('\n');
    return '-----BEGIN PUBLIC KEY-----\n$formattedPem\n-----END PUBLIC KEY-----';
  }

  TwofactorauthfeatureBloc({
    required this.localAuth,
    required this.getSecretUsecase,
    required this.verifyOtpUsecase,
    required this.localDataSource,
  }) : super(TwofactorauthfeatureInitial()) {
    on<GetSecretEvent>((event, emit) async {
      emit(TwofactorLoading());
      try {
        final email = await _storage.read(key: 'email');
        if (email == null) {
          emit(TwofactorError(message: 'البريد الإلكتروني غير موجود'));
          return;
        }

        print("البريد الإلكتروني: $email");
        final secret = await getSecretUsecase.excute(email);
        print("تم استرجاع المفتاح السري بنجاح");
        emit(TwofactorSecretLoaded(secret: secret));
      } catch (e) {
        print("خطأ أثناء جلب المفتاح: $e");
        emit(TwofactorError(message: 'فشل في جلب المفتاح السري'));
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(TwofactorLoading());
      try {
        final bool canAuthenticate = await localAuth.canCheckBiometrics;
        if (!canAuthenticate) {
          emit(TwofactorError(message: 'المصادقة البيومترية غير متوفرة'));
          return;
        }

        final bool authenticated = await localAuth.authenticate(
          localizedReason: 'قم بالمصادقة للتسجيل باستخدام Passkey',
          options: const AuthenticationOptions(biometricOnly: true),
        );

        if (!authenticated) {
          emit(TwofactorError(message: 'فشلت المصادقة البيومترية'));
          return;
        }

        final secureRandom = FortunaRandom();
        final seedSource = Random.secure();
        secureRandom.seed(
          KeyParameter(
            Uint8List.fromList(
              List.generate(32, (_) => seedSource.nextInt(256)),
            ),
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

        final publicKeyPem = encodePublicKeyToPemPKCS1(publicKey);

        final privateKeyPem = encodePrivateKeyToPemPKCS1(privateKey);

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
            emit(
              TwofactorError(
                message: 'خطأ في توليد المفتاح. الرجاء المحاولة مجددًا.',
              ),
            );
            return;
          }
        } catch (e) {
          emit(TwofactorError(message: 'تحليل المفتاح فشل قبل التخزين: $e'));
          return;
        }
        print('🔵 Sending OTP: ${event.otp}');
        print('📧 Email: ${event.email}');
        print('📱 Phone: ${event.phoneNumber}');
        print('🔑 PublicKey: $publicKeyPem');

        final result = await verifyOtpUsecase.execute(
          otp: event.otp,
          email: event.email,
          phoneNumber: event.phoneNumber,
          publickey: publicKeyPem,
        );
        print('Verify OTP Result: $result'); // طباعة الـ result
        await result.fold(
          (failure) async {
            print('Verify OTP Failure: ');
            emit(TwofactorError(message: "رمز المصادقة خطاطئ"));
          },
          (user) async {
            print('Verify OTP Success: User ID ${user.id}');
            await _storage.write(key: 'email', value: user.email);
            await localDataSource.cachePrivateKey(privateKeyPem, user.id);
            await localDataSource.cacheUserInfo(user);
            emit(
              TwofactorVerified(
                id: user.id,
                username: user.username,
                email: user.email,
                phoneNumber: event.phoneNumber,
              ),
            );
          },
        );
      } catch (e) {
        print('Verify OTP Exception: $e');
        emit(TwofactorError(message: 'فشل في التحقق من الرمز: $e'));
      }
    });
  }
}
