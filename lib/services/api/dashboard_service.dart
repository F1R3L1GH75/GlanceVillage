import 'dart:convert';
import 'dart:io';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:glancefrontend/models/dashboard_stat_response.dart';
import 'package:glancefrontend/services/api/api_routes.dart';
import 'package:glancefrontend/services/api/api_settings.dart';
import 'package:http/http.dart' as http_client;

class DashboardService {
  static Future<DashboardStatResponse> getDashboardStats() async {
    try {
      final response = await http_client.get(
          Uri.https(ApiSettings.baseUrl, ApiRoutes.dashboardRoutes.getDashboardStats),
          headers: await ApiSettings.getHeaders(addAuthToken: true));
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final success = JsonMapper.deserialize<bool>(jsonBody['succeeded']);
        if (success == true) {
          return JsonMapper.deserialize<DashboardStatResponse>(jsonBody['data'])!;
        } else {
          return Future.error(List<String>.from(jsonBody['messages']).join("\n"));
        }
      } else {
        return Future.error("Request Failed. Status Code : ${response.statusCode}");
      }
    } on SocketException {
      return Future.error("No Internet Connection!");
    } on FormatException {
      return Future.error("Bad Response Format!");
    } on Exception {
      return Future.error("Unexpected Error!");
    }
  }
}