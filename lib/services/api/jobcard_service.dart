import 'dart:convert';
import 'dart:io';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:glancefrontend/models/jobcards/jobcard_response.dart';
import 'package:glancefrontend/services/api/api_settings.dart';
import 'package:http/http.dart' as http_client;

class JobCardService {
  static Future<JobCardResponse> getJobCardByIdAsync(
      String id) async {
    try {
      final response = await http_client.get(
          Uri.https(ApiSettings.baseUrl, '/api/job-card/get'),
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
