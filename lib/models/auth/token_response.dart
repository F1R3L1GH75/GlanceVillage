import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class TokenResponse {
  late String token;
  late String refreshToken;
}