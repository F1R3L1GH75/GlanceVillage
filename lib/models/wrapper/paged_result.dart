import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class PagedResult<T> {
  List<String> messages = [];
  bool succeeded = false;
  List<T>? data;
  int currentPage = 0;
  int totalPages = 0;
  int totalCount = 0;
  int pageSize = 0;
  bool hasPreviousPage = false;
  bool hasNextPage = false;

  PagedResult(
      {required this.data,
      required this.messages,
      required this.succeeded,
      required this.currentPage,
      required this.totalPages,
      required this.totalCount,
      required this.hasNextPage,
      required this.hasPreviousPage,
      required this.pageSize});
}
