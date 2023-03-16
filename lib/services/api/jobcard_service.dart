import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:glancefrontend/models/jobcards/jobcard_response.dart';
import 'package:glancefrontend/models/wrapper/result.dart';
import 'package:glancefrontend/models/wrapper/value_result.dart';
import 'package:glancefrontend/services/api/api_settings.dart';
import 'package:glancefrontend/services/local_storage.dart';
import 'package:http/http.dart' as http_client;

class JobCardService {
  static Future<ValueResult<JobCardResponse>> getJobCardByIdAsync(
      String id) async {
    try {
      final headers = {
        'Content-Type': 'application/json; x-api-version=1.0; charset=UTF-8',
      };
      final authToken = await LocalStorage.getAuthToken();
      if (authToken != null) {
        headers['Authorization'] = 'Bearer $authToken';
      }
      final response = await http_client.get(
          Uri.https(ApiSettings.baseUrl, '/api/job-card/get'),
          headers: headers);
      if (response.statusCode == 200) {
        //return ValueResult.of<TokenResponse>(response.body);
        final jsonBody = jsonDecode(response.body);
        final success = JsonMapper.deserialize<bool>(jsonBody['succeeded']);
        if (success == true) {
          return ValueResult(
              succeeded: true,
              messages: List<String>.from(jsonBody['messages']),
              data: JsonMapper.deserialize<JobCardResponse>(jsonBody['data']));
        } else {
          return ValueResult(
              succeeded: true,
              messages: List<String>.from(jsonBody['messages']),
              data: null);
        }
      } else {
        return ValueResult(
            succeeded: false,
            messages: ["Login Failed. Status Code : ${response.statusCode}"],
            data: null);
      }
    } on SocketException {
      return ValueResult(
          succeeded: false, messages: ["No Internet Connection!"], data: null);
    } on FormatException {
      return ValueResult(
          succeeded: false, messages: ["Bad Response Format!"], data: null);
    } on Exception {
      return ValueResult(
          succeeded: false, messages: ["Unexpected Error!"], data: null);
    }
  }
}
