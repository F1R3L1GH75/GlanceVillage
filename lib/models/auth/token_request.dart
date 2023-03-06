import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class TokenRequest {
  String userName;
  String password;
  TokenRequest({required this.userName, required this.password});
}