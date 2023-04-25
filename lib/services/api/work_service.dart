import 'dart:convert';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:glancefrontend/models/works/work_full_response.dart';
import 'package:glancefrontend/models/works/work_response.dart';
import 'package:glancefrontend/models/works/workorder_attendance_response.dart';
import 'package:glancefrontend/models/works/workorder_response.dart';
import 'package:glancefrontend/models/wrapper/paged_result.dart';
import 'package:glancefrontend/models/wrapper/result.dart';
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

  static Future<WorkFullResponse> getByIdAsync(String id) async {
    final response = await http_client.get(
        Uri.https(ApiSettings.baseUrl, ApiRoutes.workRoutes.getWorkById(id)),
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded']);
      if (success == true) {
        return JsonMapper.deserialize<WorkFullResponse>(jsonBody['data'])!;
      } else {
        return Future.error(List<String>.from(jsonBody['messages']).join("\n"));
      }
    } else {
      return Future.error(
          "Request Failed. Status Code : ${response.statusCode}");
    }
  }

  static Future<List<WorkOrderResponse>> getWorkOrders(
      String workId, int pageNumber, int pageSize, String searchString) async {
    final response = await http_client.get(
        Uri.https(
            ApiSettings.baseUrl, ApiRoutes.workRoutes.getWorkOrdersByWorkId, {
          'pageNumber': pageNumber.toString(),
          'pageSize': pageSize.toString(),
          'searchString': searchString,
          'workId': workId
        }),
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded'])!;
      if (success == true) {
        return JsonMapper.deserialize<List<WorkOrderResponse>>(
            jsonBody['data'])!;
      } else {
        return Future.error(List<String>.from(jsonBody['messages']).join("\n"));
      }
    } else {
      return Future.error(
          "Request Failed. Status Code : ${response.statusCode}");
    }
  }

  static Future<Result> createWorkOrder(
      String location, double latitude, double longitude, String workId) async {
    final response = await http_client.post(
        Uri.https(ApiSettings.baseUrl, ApiRoutes.workRoutes.createWorkOrder),
        body: jsonEncode({
          "location": location,
          "latitude": latitude,
          "longitude": longitude,
          "workId": workId
        }),
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded'])!;
      if (success == true) {
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

  static Future<Result> updateWorkOrder(
      String id, String location, double latitude, double longitude) async {
    final response = await http_client.put(
        Uri.https(ApiSettings.baseUrl, ApiRoutes.workRoutes.updateWorkOrder),
        body: jsonEncode({
          "location": location,
          "latitude": latitude,
          "longitude": longitude,
          "id": id
        }),
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded'])!;
      if (success == true) {
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

  //delete workorder
  static Future<Result> deleteWorkOrder(String id) async {
    final response = await http_client.delete(
        Uri.https(
            ApiSettings.baseUrl, ApiRoutes.workRoutes.deleteWorkOrder(id)),
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded'])!;
      if (success == true) {
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

  //getAll Work Order Attendance
  static Future<List<WorkOrderAttendanceResponse>> getAllWorkOrderAttendance(
      String workOrderId,
      int pageNumber,
      int pageSize,
      String searchString) async {
    final response = await http_client.get(
        Uri.https(ApiSettings.baseUrl,
            ApiRoutes.workRoutes.getAllWorkOrderAttendance(workOrderId), {
          'pageNumber': pageNumber.toString(),
          'pageSize': pageSize.toString(),
          'searchString': searchString,
        }),
        headers: await ApiSettings.getHeaders(addAuthToken: true));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded']);
      if (success == true) {
        return JsonMapper.deserialize<List<WorkOrderAttendanceResponse>>(
            jsonBody['data'])!;
      } else {
        return Future.error(List<String>.from(jsonBody['messages']).join("\n"));
      }
    } else {
      return Future.error(
          "Request Failed. Status Code : ${response.statusCode}");
    }
  }
}
