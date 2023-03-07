import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class TokenRequest {
  String userName;
  String password;
  TokenRequest({required this.userName, required this.password});
  Map<String, dynamic> toJson() => { 'userName': userName, 'password': password };
}