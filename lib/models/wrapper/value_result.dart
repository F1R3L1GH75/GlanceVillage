import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class ValueResult<T> {

  List<String> messages = [];
  bool succeeded = false;
  T? data;

  ValueResult({required this.succeeded, required this.messages, required this.data});

  // static ValueResult<T> of<T>(String json) {
  //   final jsonBody = jsonDecode(json);
  //   final obj = JsonMapper.deserialize<T>(jsonDecode(jsonBody['data']));
  //   return ValueResult<T>(succeeded: jsonBody['succeeded'], messages: List<String>.from(jsonBody['messages'] as List), data: obj);
  // }
}