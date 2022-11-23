import 'package:encrypt/encrypt.dart';

String encrypt(String plainText){
  final key = Key.fromUtf8('oijhf8u*(JNU@(*n378wdad&2e0o^7d&');
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));
  final encrypted = encrypter.encrypt(plainText, iv: iv);

  return encrypted.base64;
}