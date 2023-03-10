import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class RefreshTokenRequest {
  String token;
  String refreshToken;

  RefreshTokenRequest({required this.token, required this.refreshToken});
  Map<String, dynamic> toJson() => { 'token': token, 'refreshToken': refreshToken };
}