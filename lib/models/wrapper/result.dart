import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class Result {
  List<String> messages = [];
  bool succeeded = false;

  Result({required this.succeeded, required this.messages});
  //
  // static Result of(dynamic jsonBody) {
  //   return Result(succeeded: jsonBody['succeeded'], messages: jsonBody['messages']);
  // }
}