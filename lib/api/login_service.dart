import 'dart:async';
import 'dart:convert';

import 'package:glancefrontend/models/auth/token_request.dart';
import 'package:glancefrontend/models/auth/token_response.dart';
import 'package:glancefrontend/models/wrapper/value_result.dart';
import 'package:http/http.dart' as http_client;

class LoginService {
  static const String _baseUrl = "https://192.168.5.131/api";

  static Future<ValueResult<TokenResponse>> loginAsync(TokenRequest request) async {
    final response = await http_client.post(
      Uri.https(_baseUrl, 'v1/token'),
      body: jsonEncode(request),
      headers: {'Content-Type': 'application/json; x-api-version=1.0; charset=UTF-8'}
    );
    if(response.statusCode == 200) {
      //return ValueResult<TokenResponse>(succeeded: body['succeeded'] as bool, messages: body['messages'] as List<String>, data: body["data"]);
      return ValueResult.of<TokenResponse>(jsonDecode(response.body));
    } else {
      throw Exception("Login Failed. Status Code : ${response.statusCode}");
    }
  }
}