import 'dart:convert';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:glancefrontend/models/jobcards/jobcard_response.dart';
import 'package:glancefrontend/models/users/user_assigned_panchayats.dart';
import 'package:glancefrontend/models/wrapper/paged_result.dart';
import 'package:glancefrontend/services/api/api_routes.dart';
import 'package:glancefrontend/services/api/api_settings.dart';
import 'package:http/http.dart' as http_client;

class JobCardService {
  static Future<JobCardResponse> getJobCardByIdAsync(String id) async {
    final response = await http_client.get(
        Uri.https(
            ApiSettings.baseUrl, ApiRoutes.jobCardRoutes.getJobCardById(id)),
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded']);
      if (success == true) {
        return JsonMapper.deserialize<JobCardResponse>(jsonBody['data'])!;
      } else {
        return Future.error(List<String>.from(jsonBody['messages']).join("\n"));
      }
    } else {
      return Future.error(
          "Request Failed. Status Code : ${response.statusCode}");
    }
  }

  static Future<JobCardResponse> getJobCardByCardNumber(String cardno) async {
    final response = await http_client.get(
        Uri.https(ApiSettings.baseUrl,
            ApiRoutes.jobCardRoutes.getJobCardByCardNumber, {'cardno': cardno}),
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    try {
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final success = JsonMapper.deserialize<bool>(jsonBody['succeeded']);
        if (success == true) {
          return JsonMapper.deserialize<JobCardResponse>(jsonBody['data'])!;
        } else {
          return Future.error(
              List<String>.from(jsonBody['messages']).join("\n"));
        }
      } else {
        return Future.error(
            "Request Failed. Status Code : ${response.statusCode}");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<PagedResult<JobCardResponse>> getAll(int pageNumber,
      int pageSize, String searchQuery, PanchayatResponse panchayat) async {
    final response = await http_client.post(
        Uri.https(ApiSettings.baseUrl, ApiRoutes.jobCardRoutes.getAll),
        headers: await ApiSettings.getHeaders(addAuthToken: true),
        body: jsonEncode({
          'pageNumber': pageNumber,
          'pageSize': pageSize,
          'searchQuery': searchQuery,
          'panchayat': panchayat
        }));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded'])!;
      final currentPage = JsonMapper.deserialize<int>(jsonBody['currentPage'])!;
      final totalPages = JsonMapper.deserialize<int>(jsonBody['totalPages'])!;
      final totalCount = JsonMapper.deserialize<int>(jsonBody['totalCount'])!;
      final pageSize = JsonMapper.deserialize<int>(jsonBody['pageSize'])!;
      final em =
          JsonMapper.deserialize<List<JobCardResponse>>(jsonBody['data'])!;
      return PagedResult(
          data: em,
          messages: List<String>.from(jsonBody['messages']),
          succeeded: success,
          currentPage: currentPage,
          totalPages: totalPages,
          totalCount: totalCount,
          hasNextPage: currentPage < totalPages,
          hasPreviousPage: currentPage > 1,
          pageSize: pageSize);
    } else {
      return Future.error(
          "Request Failed. Status Code : ${response.statusCode}");
    }
  }

  static Future<List<int>> getJobCardFingerprint(String id) async {
    final response = await http_client.get(
        Uri.https(
            ApiSettings.baseUrl, ApiRoutes.jobCardRoutes.getFingerprint(id)),
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded']);
      if (success == true) {
        return base64Decode(jsonBody['data'] as String);
      } else {
        return Future.error(List<String>.from(jsonBody['messages']).join("\n"));
      }
    } else {
      return Future.error(
          "Request Failed. Status Code : ${response.statusCode}");
    }
  }
}
