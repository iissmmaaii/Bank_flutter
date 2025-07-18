// rsa_utils.dart

import 'dart:convert';
import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RSAUtils {
  static RSAPrivateKey parsePrivateKeyFromPem(String pemString) {
    final lines =
        pemString
            .split('\n')
            .where(
              (line) =>
                  !line.startsWith('-----BEGIN') &&
                  !line.startsWith('-----END'),
            )
            .toList();

    final base64Str = lines.join('');
    final bytes = base64Decode(base64Str);

    final asn1Parser = ASN1Parser(bytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    if (topLevelSeq.elements.length != 9) {
      throw FormatException('Expected 9 elements in PKCS#1 sequence');
    }

    final n = (topLevelSeq.elements[1] as ASN1Integer).valueAsBigInteger;
    final e = (topLevelSeq.elements[2] as ASN1Integer).valueAsBigInteger;
    final p = (topLevelSeq.elements[3] as ASN1Integer).valueAsBigInteger;
    final q = (topLevelSeq.elements[4] as ASN1Integer).valueAsBigInteger;

    return RSAPrivateKey(n!, e!, p!, q!);
  }
}
