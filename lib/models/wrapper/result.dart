class Result {
  List<String> messages;
  bool succeeded;

  Result({required this.succeeded, required this.messages});

  static Result of(dynamic jsonBody) {
    return Result(succeeded: jsonBody['succeeded'], messages: jsonBody['messages']);
  }
}