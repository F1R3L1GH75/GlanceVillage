import 'dart:convert';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:glancefrontend/models/wrapper/result.dart';
import 'package:glancefrontend/services/api/api_routes.dart';
import 'package:glancefrontend/services/api/api_settings.dart';
import 'package:http/http.dart' as http_client;

class AttendanceService {
  static Future<Result> markAttendanceIn(
      String jobCardId, String workOrderId, double? lat, double? long) async {
    final response = await http_client.post(
        Uri.https(ApiSettings.baseUrl, ApiRoutes.attendanceRoutes.attendanceIn),
        body: {
          'jobCardId': jobCardId,
          'workOrderId': workOrderId,
          'timeIn': DateTime.now(),
          'latitude': lat ?? 0,
          'longitude': long ?? 0
        },
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded'])!;
      if (success) {
        return Result(
            messages: List<String>.from(jsonBody['messages']),
            succeeded: success);
      } else {
        return Future.error(List<String>.from(jsonBody['messages']).join("\n"));
      }
    } else {
      return Future.error(
          "Request Failed. Status Code : ${response.statusCode}");
    }
  }

  static Future<Result> markAttendanceOut(
      String jobCardId, String workOrderId, double? lat, double? long) async {
    final response = await http_client.post(
        Uri.https(
            ApiSettings.baseUrl, ApiRoutes.attendanceRoutes.attendanceOut),
        body: {
          'jobCardId': jobCardId,
          'workOrderId': workOrderId,
          'timeOut': DateTime.now(),
          'latitude': lat ?? 0,
          'longitude': long ?? 0
        },
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded'])!;
      if (success) {
        return Result(
            messages: List<String>.from(jsonBody['messages']),
            succeeded: success);
      } else {
        return Future.error(List<String>.from(jsonBody['messages']).join("\n"));
      }
    } else {
      return Future.error(
          "Request Failed. Status Code : ${response.statusCode}");
    }
  }
}
