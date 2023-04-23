import 'dart:convert';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:glancefrontend/models/works/work_response.dart';
import 'package:glancefrontend/models/wrapper/paged_result.dart';
import 'package:glancefrontend/services/api/api_routes.dart';
import 'package:glancefrontend/services/api/api_settings.dart';
import 'package:http/http.dart' as http_client;

class WorkService {
  static Future<PagedResult<WorkResponse>> getAll(int pageNumber, int pageSize,
      String searchString, String panchayatId) async {
    final response = await http_client.get(
        Uri.https(ApiSettings.baseUrl, ApiRoutes.workRoutes.getAll, {
          'pageNumber': pageNumber.toString(),
          'pageSize': pageSize.toString(),
          'searchString': searchString,
          'panchayatId': panchayatId
        }),
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded'])!;
      final currentPage = JsonMapper.deserialize<int>(jsonBody['currentPage'])!;
      final totalPages = JsonMapper.deserialize<int>(jsonBody['totalPages'])!;
      final totalItems = JsonMapper.deserialize<int>(jsonBody['totalCount'])!;
      final items =
          JsonMapper.deserialize<List<WorkResponse>>(jsonBody['data'])!;
      return PagedResult(
          messages: List<String>.from(jsonBody['messages']),
          succeeded: success,
          data: items,
          currentPage: currentPage,
          totalPages: totalPages,
          totalCount: totalItems,
          pageSize: pageSize,
          hasNextPage: currentPage < totalPages,
          hasPreviousPage: currentPage > 1);
    } else {
      return Future.error(
          "Request Failed. Status Code : ${response.statusCode}");
    }
  }

  static Future<WorkResponse> getByIdAsync(String id) async {
    final response = await http_client.get(
        Uri.https(ApiSettings.baseUrl, ApiRoutes.workRoutes.getWorkById(id)),
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded']);
      if (success == true) {
        return JsonMapper.deserialize<WorkResponse>(jsonBody['data'])!;
      } else {
        return Future.error(List<String>.from(jsonBody['messages']).join("\n"));
      }
    } else {
      return Future.error(
          "Request Failed. Status Code : ${response.statusCode}");
    }
  }
}
