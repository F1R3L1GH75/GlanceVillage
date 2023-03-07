import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class TokenResponse {
  late String token = '';
  late String refreshToken = '';
  late DateTime refreshTokenExpiryTime = DateTime.now();
}