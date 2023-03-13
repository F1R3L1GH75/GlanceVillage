import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class TokenRequest {
  String userName;
  String password;
  String role;
  TokenRequest(
      {required this.userName, required this.password, required this.role});
  Map<String, dynamic> toJson() =>
      {'userName': userName, 'password': password, 'role': role};
}
