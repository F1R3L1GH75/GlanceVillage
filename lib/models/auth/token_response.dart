import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class TokenResponse {
  String token = '';
  String refreshToken = '';
  DateTime refreshTokenExpiryTime = DateTime.now();
}