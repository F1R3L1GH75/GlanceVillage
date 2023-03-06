class ValueResult<T> {

  List<String> messages;
  bool succeeded;
  T? data;

  ValueResult({required this.succeeded, required this.messages, required this.data});

  static ValueResult<T> of<T>(dynamic jsonBody) {
    return ValueResult(succeeded: jsonBody['succeeded'], messages: jsonBody['messages'], data: jsonBody['data']);
  }
}