import 'dart:convert';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:glancefrontend/models/users/user_assigned_panchayats.dart';
import 'package:glancefrontend/services/api/api_routes.dart';
import 'package:glancefrontend/services/api/api_settings.dart';
import 'package:glancefrontend/services/claim_data_service.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<UserAssignedPanchayats> getUserAssignedPanchayats() async {
    final userid = await ClaimDataService.getUserId();
    final response = await http.get(
        headers: await ApiSettings.getHeaders(addAuthToken: true),
        Uri.https(ApiSettings.baseUrl,
            ApiRoutes.usersRoutes.getUserAssignedPanchayats(userid)));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final success = JsonMapper.deserialize<bool>(jsonBody['succeeded']);
      if (success == true) {
        return JsonMapper.deserialize<UserAssignedPanchayats>(
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
