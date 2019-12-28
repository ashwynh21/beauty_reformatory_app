import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

String generateID() {
  return md5.convert(utf8.encode(base64Url.encode(List<int>.generate(32, (i) => Random.secure().nextInt(256))))).toString();
}