import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class ValueResult<T> {

  List<String> messages = [];
  bool succeeded = false;
  T? data;

  // ValueResult(this.succeeded, this.messages, this.data);
  //
  // static ValueResult<T> of<T>(dynamic jsonBody) {
  //   return ValueResult(succeeded: jsonBody['succeeded'], messages: List<String>.from(jsonBody['messages'] as List), data: jsonBody['data']);
  // }
}