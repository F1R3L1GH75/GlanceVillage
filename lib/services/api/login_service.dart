import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:glancefrontend/models/auth/refresh_token_request.dart';
import 'package:glancefrontend/models/auth/token_request.dart';
import 'package:glancefrontend/models/auth/token_response.dart';
import 'package:glancefrontend/models/wrapper/result.dart';
import 'package:glancefrontend/services/local_storage.dart';
import 'package:http/http.dart' as http_client;

class LoginService {
  static const String _baseUrl = "glance.sathiyaraman-m.com";

  static Future<Result> loginAsync(TokenRequest request) async {
    try {
      final response = await http_client.post(
          Uri.https(_baseUrl, 'api/v1/token'),
          body: jsonEncode(request),
          headers: {'Content-Type': 'application/json; x-api-version=1.0; charset=UTF-8'}
      );
      if(response.statusCode == 200) {
        //return ValueResult.of<TokenResponse>(response.body);
        final jsonBody = jsonDecode(response.body);
        TokenResponse? obj = JsonMapper.deserialize<TokenResponse>(jsonBody['data']);
        LocalStorage.setAuthToken(obj!.token);
        LocalStorage.setRefreshToken(obj.refreshToken);
        return Result(succeeded: true, messages: List<String>.from(jsonBody['messages'] as List));
      } else {
        return Result(succeeded: false, messages: ["Login Failed. Status Code : ${response.statusCode}"]);
      }
    } on SocketException {
      return Result(succeeded: false, messages: ["No Internet Connection!"]);
    } on FormatException {
      return Result(succeeded: false, messages: ["Bad Response Format!"]);
    } on Exception {
      return Result(succeeded: false, messages: ["Unexpected Error!"]);
    }
  }

  static Future<Result> refreshTokenAsync(RefreshTokenRequest request) async {
    try {
      final response = await http_client.post(
        Uri.https(_baseUrl, 'api/v1/token/refresh'),
        body: jsonEncode(request),
        headers: {'Content-Type': 'application/json; x-api-version=1.0; charset=UTF-8'}
      );
      if(response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        TokenResponse? obj = JsonMapper.deserialize<TokenResponse>(jsonBody['data']);
        LocalStorage.setAuthToken(obj!.token);
        LocalStorage.setRefreshToken(obj.refreshToken);
        return Result(succeeded: true, messages: List<String>.from(jsonBody['messages'] as List));
      } else {
        return Result(succeeded: false, messages: ["Refresh Token Failed. Status Code : ${response.statusCode}"]);
      }
    } on SocketException {
      return Result(succeeded: false, messages: ["No Internet Connection!"]);
    } on FormatException {
      return Result(succeeded: false, messages: ["Bad Response Format!"]);
    } on Exception {
      return Result(succeeded: false, messages: ["Unexpected Error!"]);
    }
  }

  static Future<Result> logoutAsync() async {
    await LocalStorage.deleteAll();
    return Result(succeeded: true, messages: ['Logged out successfully!']);
  }
}