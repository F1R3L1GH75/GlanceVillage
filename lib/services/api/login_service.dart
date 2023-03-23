import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:glancefrontend/models/auth/refresh_token_request.dart';
import 'package:glancefrontend/models/auth/token_request.dart';
import 'package:glancefrontend/models/auth/token_response.dart';
import 'package:glancefrontend/models/wrapper/result.dart';
import 'package:glancefrontend/services/api/api_routes.dart';
import 'package:glancefrontend/services/api/api_settings.dart';
import 'package:glancefrontend/services/local_storage.dart';
import 'package:http/http.dart' as http_client;

class LoginService {
  static Future<Result> loginAsync(TokenRequest request) async {
    try {
      final response = await http_client.post(
          Uri.https(ApiSettings.baseUrl, ApiRoutes.usersRoutes.login),
          body: jsonEncode(request),
          headers: await ApiSettings.getHeaders(addAuthToken: false));
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final success = JsonMapper.deserialize<bool>(jsonBody['succeeded']);
        if (!success!) {
          return Future.error(List<String>.from(jsonBody['messages']).join("\n"));
        } else {
          TokenResponse? obj =
              JsonMapper.deserialize<TokenResponse>(jsonBody['data']);
          LocalStorage.setAuthToken(obj!.token);
          LocalStorage.setRefreshToken(obj.refreshToken);
          return Result(
              succeeded: true,
              messages: List<String>.from(jsonBody['messages'] as List));
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

  static Future<Result> refreshTokenAsync(RefreshTokenRequest request) async {
    try {
      final response = await http_client.post(
          Uri.https(ApiSettings.baseUrl, ApiRoutes.usersRoutes.refreshToken),
          body: jsonEncode(request),
          headers: await ApiSettings.getHeaders(addAuthToken: false));
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        TokenResponse? obj =
            JsonMapper.deserialize<TokenResponse>(jsonBody['data']);
        LocalStorage.setAuthToken(obj!.token);
        LocalStorage.setRefreshToken(obj.refreshToken);
        return Result(
            succeeded: true,
            messages: List<String>.from(jsonBody['messages'] as List));
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

  static Future<Result> logoutAsync() async {
    await LocalStorage.deleteAll();
    return Result(succeeded: true, messages: ['Logged out successfully!']);
  }
}
